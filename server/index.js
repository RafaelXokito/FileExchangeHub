const express = require("express");
const cors = require("cors");
const fs = require("fs");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const Room = require("./models/Room");
const multer = require("multer");
const axios = require("axios");
const FormData = require("form-data");

const app = express();
const PORT = process.env.PORT || 3001;

var database_uri = process.env.DATABASE_URI || "localhost";
var file_gateway_uri = process.env.FILE_GATEWAY_URI || "http://localhost:3003";
// Replace 'your-database-name' with the name of your database
const MONGODB_URI = database_uri.startsWith("mongodb+srv://")
  ? database_uri
  : `mongodb://${database_uri}:27017/fileexchangehub`;

mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log("MongoDB connection error:", err));

const db = mongoose.connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, file_gateway_uri.includes("localhost") ? "uploads/" : "/tmp");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({
  storage: storage,
});

app.use(cors());
app.use(bodyParser.json());

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

app.post("/api/rooms", async (req, res) => {
  const roomCode = req.body.roomCode;

  if (!roomCode) {
    return res.status(400).json({
      error: "Room code is required",
    });
  }

  try {
    const existingRoom = await Room.findOne({
      roomCode,
    });

    if (existingRoom) {
      return res.status(400).json({
        error: "Room code already exists",
      });
    }

    const newRoom = new Room({
      roomCode,
      messages: [],
    });
    await newRoom.save();

    res.status(200).json({
      roomCode,
    });
  } catch (error) {
    res.status(500).json({
      error: "Internal server error",
    });
  }
});

app.get("/api/rooms/:roomCode", async (req, res) => {
  const roomCode = req.params.roomCode;

  try {
    const room = await Room.findOne({
      roomCode,
    });

    if (!room) {
      return res.status(404).json({
        error: "Room not found",
      });
    }

    res.status(200).json({
      roomCode,
    });
  } catch (error) {
    res.status(500).json({
      error: "Internal server error",
    });
  }
});

app.post(
  "/api/rooms/:roomCode/messages",
  upload.single("file"),
  async (req, res) => {
    const roomCode = req.params.roomCode;
    const file = req.file;
    try {
      const room = await Room.findOne({
        roomCode,
      });

      console.log(room);

      if (!room) {
        fs.unlinkSync(file.path);
        return res.status(404).json({
          error: "Room not found",
        });
      }

      if (!file) {
        fs.unlinkSync(file.path);
        return res.status(400).json({
          error: "File is required",
        });
      }

      try {
        const formData = new FormData();
        
        formData.append(
          "file",
          fs.createReadStream(file.path),
          file.originalname
        );

        // Make the POST request using axios with the FormData instance
        const response = await axios.post(
          `${file_gateway_uri}/upload`,
          formData,
          {
            headers: {
              ...formData.getHeaders(),
            },
          }
        );

        // Save the file URL and timestamp to MongoDB
        const newMessage = {
          fileUrl: response.data.url,
          timestamp: new Date(),
        };

        room.messages.push(newMessage);
        await room.save();

        res.status(200).json({
          message: newMessage,
        });
        fs.unlinkSync(file.path);
      } catch (error) {
        fs.unlinkSync(file.path);
        console.log(error);
        res.status(500).json({
          error: "Error uploading the file",
        });
      }
    } catch (error) {
      fs.unlinkSync(file.path);

      res.status(500).json({
        error: "Internal server error",
      });
      console.log(error);
    }
  }
);

app.get("/api/rooms/:roomCode/messages", async (req, res) => {
  const roomCode = req.params.roomCode;

  try {
    const room = await Room.findOne({
      roomCode,
    });

    if (!room) {
      return res.status(404).json({
        error: "Room not found",
      });
    }

    const availableMessages = room.messages.filter(
      (message) => message.expiresAt > new Date()
    );

    res.status(200).json({
      messages: availableMessages,
    });
  } catch (error) {
    res.status(500).json({
      error: "Internal server error",
    });
  }
});

// Modify this part in your existing code
app.get("/api/rooms/:roomCode/messages/:fileUrl", async (req, res) => {
  const fileUrl = req.params.fileUrl;
  const roomCode = req.params.roomCode;
 
  try {
    const room = await Room.findOne({
      roomCode,
    });

    console.log(room);

    if (!room) {
      return res.status(404).json({
        error: "Room not found",
      });
    }

    // Forward the file download request to the file-gateway
    try {
      const response = await axios.get(`${file_gateway_uri}/files/${fileUrl}`, {
        responseType: "stream",
      });

      // Pipe the file stream to the response
      res.setHeader("Content-Disposition", `attachment; filename=${fileUrl}`);

      response.data.pipe(res);
    } catch (error) {
      res.status(500).json({
        error: "Error downloading the file",
      });
    }
  } catch (error) {
    res.status(500).json({
      error: "Internal server error",
    });
  }
});
