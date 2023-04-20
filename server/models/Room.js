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
  expiresAt: {
    type: Date,
    default: () => new Date(Date.now() + 24 * 60 * 60 * 1000), // 1 day in the future
    index: { expires: '1d' },
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