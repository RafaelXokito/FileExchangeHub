const express = require("express");
const cors = require("cors");
const multer = require("multer");
const axios = require("axios");

const app = express();
const PORT = process.env.PORT || 3003;

const isProduction = (process.env.IS_PRODUCTION ? process.env.IS_PRODUCTION : "FALSE") === "TRUE";

const storage = isProduction
  ? require('./production-storage')
  : require('./development-storage');

const upload = multer({ storage: storage.storage });

app.use(cors());

app.listen(PORT, () => {
  console.log(`Gateway running on port ${PORT}`);
});

app.post("/upload", upload.single("file"), async (req, res) => {
  try {
    const file = req.file;
    url = "";
    if (isProduction === true) {
      url = await storage.uploadToGCP(file);
    } else {
      url = await storage.getFileURL(file);
    }

    res.status(200).json({ url });
  } catch (error) {
    console.error('Error in file upload:', error);
    res.status(500).json({ error: "Error uploading file" });
  }
});

app.get("/files/:filename", async (req, res) => {
  try {
    const filename = req.params.filename;
    const fileStream = await storage.getFileStream(filename);

    // Set the Content-Disposition header
    res.setHeader('Content-Disposition', `attachment; filename=${filename}`);

    fileStream.pipe(res);
  } catch (error) {
    res.status(404).json({ error: "File not found" });
  }
});