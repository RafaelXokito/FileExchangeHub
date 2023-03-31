import axios from 'axios';

function generateRoomCode(length = 6) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
  
    for (let i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * characters.length));
    }
  
  return result;
}

export const createRoom = async () => {
    const roomCode = generateRoomCode();
    try {
      // Replace with your API endpoint
      const response = await axios.post('http://__SERVER_URI__/api/rooms', {
        roomCode: roomCode,
      });
  
      if (response.status === 200) {
        // If room creation is successful, navigate to the room page
        window.location.href = `/rooms/${roomCode}`;
      } else {
        // Handle error during room creation
        console.error('Error creating room:', response.status);
        alert('Error creating room. Please try again.');
      }
    } catch (error) {
      console.error('Error creating room:', error);
      alert('Error creating room. Please try again.');
    }
  };

export const joinRoom = async (roomCode) => {
    try {
        // Replace with your API endpoint
        const response = await axios.get(`http://__SERVER_URI__/api/rooms/${roomCode}`);
        
        if (response.status === 200) {
          // If room exists, navigate to the room page
          window.location.href = `/rooms/${roomCode}`;
        } else {
          // Handle error during room joining
          console.error('Error joining room:', response.status);
          alert('Error joining room. Please check the room code and try again.');
        }
    } catch (error) {
        console.error('Error joining room:', error);
        alert('Error joining room. Please check the room code and try again.');
    }
};
