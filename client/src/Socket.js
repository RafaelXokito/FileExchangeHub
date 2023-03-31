import { io } from 'socket.io-client';

const SOCKET_SERVER_URL = 'http://__SOCKET_URI__'; // Update this URL to match your Socket.IO server's URL
const socket = io(SOCKET_SERVER_URL);

export default socket;
