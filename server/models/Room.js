const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  fileUrl: {
    type: String,
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

const roomSchema = new mongoose.Schema({
  roomCode: {
    type: String,
    required: true,
    unique: true,
  },
  messages: [messageSchema],
});

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;