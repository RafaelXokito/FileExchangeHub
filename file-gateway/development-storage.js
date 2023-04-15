const multer = require("multer");
const fs = require("fs");
const path = require("path");

const UPLOADS_DIR = "uploads";

if (!fs.existsSync(UPLOADS_DIR)) {
  fs.mkdirSync(UPLOADS_DIR);
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, UPLOADS_DIR);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const getFileURL = (file) => {
  return `/${file.filename}`;
};

const getFileStream = (filename) => {
  const filePath = path.join(UPLOADS_DIR, filename);
  return fs.createReadStream(filePath);
};

console.log('Development storage:', storage);
module.exports = {
    storage: storage,
    getFileURL: getFileURL,
    getFileStream: getFileStream,
};