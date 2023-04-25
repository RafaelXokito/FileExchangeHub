const { Octokit } = require("@octokit/core");
const sodium = require("libsodium-wrappers");

async function updateSecret(owner, repo, secretName, secretValue, token) {
  const octokit = new Octokit({ auth: token });

  const publicKeyResponse = await octokit.request(
    "GET /repos/{owner}/{repo}/actions/secrets/public-key",
    { owner, repo }
  );

  await sodium.ready;

  const publicKey = publicKeyResponse.data.key;
  const keyId = publicKeyResponse.data.key_id;

  const binKey = sodium.from_base64(publicKey, sodium.base64_variants.ORIGINAL);
  const binSecret = sodium.from_string(secretValue);

  const encryptedBytes = sodium.crypto_box_seal(binSecret, binKey);
  const encryptedValue = sodium.to_base64(encryptedBytes, sodium.base64_variants.ORIGINAL);

  await octokit.request(
    "PUT /repos/{owner}/{repo}/actions/secrets/{secret_name}",
    {
      owner,
      repo,
      secret_name: secretName,
      encrypted_value: encryptedValue,
      key_id: keyId,
      headers: {
        "X-GitHub-Api-Version": "2022-11-28",
      },
    }
  );
}

(async () => {
  if (process.argv.length < 5) {
    console.error("Usage: node update_secret.js <secret_name> <secret_value>");
    process.exit(1);
  }

  const secretName = process.argv[2];
  const secretValue = process.argv[3];
  const owner = process.env.GITHUB_REPOSITORY_OWNER;
  const repo = process.env.GITHUB_REPOSITORY_NAME;
  const token = process.env.GITHUB_TOKEN;

  await updateSecret(owner, repo, secretName, secretValue, token);
})();
