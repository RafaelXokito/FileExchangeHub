const { Octokit } = require('@octokit/core');
const sodium = require('libsodium-wrappers');

if (process.argv.length < 4) {
  console.error('Usage: node update_secret.js <secret_name> <secret_value>');
  process.exit(1);
}

const secretName = process.argv[2];
const secretValue = process.argv[3];

(async () => {
  await sodium.ready;

  const token = process.env.GITHUB_TOKEN;
  const owner = process.env.GITHUB_REPOSITORY_OWNER;
  const repo = process.env.GITHUB_REPOSITORY_NAME;

  const octokit = new Octokit({ auth: token });

  // Fetch public key for the repository
  const { data: publicKey } = await octokit.request('GET /repos/{owner}/{repo}/actions/secrets/public-key', {
    owner,
    repo,
  });

  // Encrypt the secret using the public key
  const encryptedValue = sodium.crypto_box_seal_easy(secretValue, sodium.from_base64(publicKey.key, sodium.base64_variants.ORIGINAL), 'base64', sodium.base64_variants.ORIGINAL);

  // Update or create the secret in the GitHub repository
  await octokit.request('PUT /repos/{owner}/{repo}/actions/secrets/{secret_name}', {
    owner,
    repo,
    secret_name: secretName,
    encrypted_value: encryptedValue,
    key_id: publicKey.key_id,
  });

  console.log(`Secret "${secretName}" has been updated.`);
})();
