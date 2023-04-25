const sodium = require('libsodium-wrappers');
const fs = require('fs');

const secret = process.argv[2];
const key = process.argv[3];

sodium.ready.then(() => {
  const binKey = sodium.from_base64(key, sodium.base64_variants.ORIGINAL);
  const binSec = sodium.from_string(secret);

  const encBytes = sodium.crypto_box_seal(binSec, binKey);

  const output = sodium.to_base64(encBytes, sodium.base64_variants.ORIGINAL);

  fs.writeFileSync('encrypted_secret.txt', output);
});
