const http = require('http');
const { Server } = require('socket.io');

const PORT = process.env.PORT || 3002;

const httpServer = http.createServer();
const io = new Server(httpServer, {
  cors: {
    origin: '*', // You should update this to match your frontend's origin
    methods: ['GET', 'POST'],
  },
});

io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  socket.on('joinRoom', (roomCode) => {
    socket.join(roomCode);
  });

  socket.on('sendMessage', (roomCode, message) => {
    io.to(roomCode).emit('receiveMessage', message);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

httpServer.listen(PORT, () => {
  console.log(`Socket.IO server running on port ${PORT}`);
}); 