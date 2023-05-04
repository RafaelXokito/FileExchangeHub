import { useRef } from "react";
import { createRoom, joinRoom } from "./utils/roomUtils";

function Main() {
  const roomCodeInput = useRef();

  const handleCreateRoom = () => {
    createRoom();
  };

  const handleJoinRoomClick = () => {
    const roomCode = roomCodeInput.current.value;

    if (roomCode) {
      joinRoom(roomCode);
    } else {
      alert("Please enter a room code.");
    }
  };

  return (
    <div className="app">
      <img
        src={process.env.PUBLIC_URL + "/logo512.png"}
        alt="FileExchange Hub Logo"
        className="app-logo"
      />
      <h1 className="app-name">File Exchange Hub</h1>
      <div className="room-input-container">
        <input
          className="room-input"
          type="text"
          placeholder="Enter room code"
          ref={roomCodeInput}
        />
        <button className="join-room-btn" onClick={handleJoinRoomClick}>
          Join Room
        </button>
        <button className="create-room-btn" onClick={handleCreateRoom}>
          Create Room
        </button>
      </div>
      <footer>
        <p>
          <a href="https://www.flaticon.com/free-icons/folder" title="Folder icons created by Freepik - Flaticon">
            Folder icons created by Freepik - Flaticon
          </a>
        </p> 
      </footer>
    </div>
  );
}

export default Main;
