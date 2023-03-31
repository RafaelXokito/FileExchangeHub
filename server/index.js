const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const Room = require('./models/Room');
const multer = require('multer');

const {
    BlobServiceClient
} = require('@azure/storage-blob');
const AZURE_STORAGE_CONNECTION_STRING = 'BlobEndpoint=https://fileexchangehub.blob.core.windows.net/;QueueEndpoint=https://fileexchangehub.queue.core.windows.net/;FileEndpoint=https://fileexchangehub.file.core.windows.net/;TableEndpoint=https://fileexchangehub.table.core.windows.net/;SharedAccessSignature=sv=2021-12-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-04-07T23:00:00Z&st=2023-03-30T23:00:00Z&spr=https,http&sig=bnv%2FH%2BtdWJyzQfw9MBx7ndjUWI4WUPVEWem3GygJ5Cg%3D';
const blobServiceClient = BlobServiceClient.fromConnectionString(AZURE_STORAGE_CONNECTION_STRING);

const app = express();
const PORT = process.env.PORT || 3001;

var database_uri = process.env.DATABASE_URI || 'localhost';
// Replace 'your-database-name' with the name of your database
const MONGODB_URI = `mongodb://${database_uri}:27017/fileexchangehub`;

mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log('MongoDB connected'))
  .catch((err) => console.log('MongoDB connection error:', err));

const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB connection error:'));
db.once('open', () => {
    console.log('Connected to MongoDB');
});

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname);
    },
});

const upload = multer({
    storage: storage
});

app.use(cors());
app.use(bodyParser.json());

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

app.post('/api/rooms', async (req, res) => {
    const roomCode = req.body.roomCode;

    if (!roomCode) {
        return res.status(400).json({
            error: 'Room code is required'
        });
    }

    try {
        const existingRoom = await Room.findOne({
            roomCode
        });

        if (existingRoom) {
            return res.status(400).json({
                error: 'Room code already exists'
            });
        }

        const newRoom = new Room({
            roomCode,
            messages: []
        });
        await newRoom.save();

        res.status(200).json({
            roomCode
        });
    } catch (error) {
        res.status(500).json({
            error: 'Internal server error'
        });
    }
});

app.get('/api/rooms/:roomCode', async (req, res) => {
    const roomCode = req.params.roomCode;

    try {
        const room = await Room.findOne({
            roomCode
        });

        if (!room) {
            return res.status(404).json({
                error: 'Room not found'
            });
        }

        res.status(200).json({
            roomCode
        });
    } catch (error) {
        res.status(500).json({
            error: 'Internal server error'
        });
    }
});

app.post('/api/rooms/:roomCode/messages', upload.single('file'), async (req, res) => {
    const roomCode = req.params.roomCode;
    const file = req.file;

    try {
        const room = await Room.findOne({
            roomCode
        });

        console.log(room);

        if (!room) {
            return res.status(404).json({
                error: 'Room not found'
            });
        }

        if (!file) {
            return res.status(400).json({
                error: 'File is required'
            });
        }

        const zipFileName = `${Date.now()}-${file.originalname}`;

        const containerName = 'fileexchangehubmain';
        const containerClient = blobServiceClient.getContainerClient(containerName);
        const blockBlobClient = containerClient.getBlockBlobClient(zipFileName);

        const uploadBlobResponse = blockBlobClient.uploadFile(file.path)

        uploadBlobResponse.then( async () => {

            // Save the file URL and timestamp to MongoDB
            const newMessage = {
                fileUrl: blockBlobClient.url,
                timestamp: new Date(),
            };

            room.messages.push(newMessage);
            await room.save();

            res.status(200).json({
                message: newMessage
            });
        }).catch( (error) => {
            res.status(500).json({
                error: 'Error compressing and uploading the file'
            });
        });

    } catch (error) {
        res.status(500).json({
            error: 'Internal server error'
        });
        console.log(error);
    }
});


app.get('/api/rooms/:roomCode/messages', async (req, res) => {
    const roomCode = req.params.roomCode;

    try {
        const room = await Room.findOne({
            roomCode
        });

        if (!room) {
            return res.status(404).json({
                error: 'Room not found'
            });
        }

        res.status(200).json({
            messages: room.messages
        });
    } catch (error) {
        res.status(500).json({
            error: 'Internal server error'
        });
    }
});