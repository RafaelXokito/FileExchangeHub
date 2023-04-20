const { Storage } = require("@google-cloud/storage");
const multer = require("multer");
const stream = require('stream');
const storage = new Storage({
  projectId: "fileexchangehub",
  keyFilename: "./auth.json",
});

const bucketName = "fileexchange-bucket";
const bucket = storage.bucket(bucketName);

const memoryStorage = multer.memoryStorage();

const uploadToGCP = async (file) => {
  const blobName = `${Date.now()}-${file.originalname}`;
  const blob = bucket.file(blobName);

  const readableStream = new stream.PassThrough();
  readableStream.end(file.buffer);

  await new Promise((resolve, reject) => {
    readableStream.pipe(blob.createWriteStream({
      metadata: { contentType: file.mimetype },
      resumable: false,
    }))
    .on('error', (err) => {
      console.error(err);
      reject(err);
    })
    .on('finish', () => {
      resolve();
    });
  });

  // https://storage.googleapis.com/${bucketName}
  return `/${blobName}`;
};

// URL = /1681692099463-bucket.png
const getFileStream = async (url) => {
  const blobName = url.split("/").pop();
  const blob = bucket.file(blobName);

  return blob.createReadStream();
};

module.exports = {
  storage: memoryStorage,
  getFileURL: uploadToGCP,
  getFileStream: getFileStream,
};
