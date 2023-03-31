import axios from "axios";
import { useParams, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import "./Room.css";

import { FaFileUpload } from "react-icons/fa";
import { FaPaperPlane } from "react-icons/fa";
import { FaArrowLeft } from 'react-icons/fa';

import LoadingPopup from './LoadingPopup';

import socket from './Socket';

function Room() {
  const { roomCode } = useParams();
  const [messages, setMessages] = useState([]);
  const [newMessage, setNewMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const history = useNavigate();

  const handleBack = () => {
    history(-1);
  };

  useEffect(() => {
    async function fetchMessages() {
      try {
        const response = await axios.get(
          `http://__SERVER_URI__/api/rooms/${roomCode}/messages`
        );
        
        if (response.status === 200) {
          setMessages(response.data.messages);
        } else {
          console.error("Error fetching messages:", response.status);
          alert("Error fetching messages. Please try again later.");
        }
      } catch (error) {
        if (error.response && error.response.status === 404) {
          alert("Error: Room code not found.");
          history(-1);
        } else {
          console.error("Error fetching messages:", error);
          alert("Error fetching messages. Please try again later.");
        }
      }
    }

    fetchMessages();

    // Join the room
    socket.emit('joinRoom', roomCode);

    // Listen for new messages
    socket.on('receiveMessage', (message) => {
      setMessages((messages) => [...messages, message]);
    });

    return () => {
      socket.off('receiveMessage');
    };
  }, [roomCode]);

  const sendMessage = async (e) => {
    e.preventDefault();

    const fileInput = document.getElementById("fileInput");
    const file = fileInput.files[0];

    if (!file) {
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    setIsLoading(true);

    try {
      const response = await axios.post(
        `http://__SERVER_URI__/api/rooms/${roomCode}/messages`,
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        }
      );
        
      socket.emit('sendMessage', roomCode, response.data.message);
      // setMessages([...messages, response.data.message]);
      fileInput.value = ""; // Clear the file input
    } catch (error) {
      console.error("Error uploading file:", error);
      alert("Error uploading file:", error);
    }
    setIsLoading(false);
  };

  return (
    <div className="room">
      <button className="back-button" onClick={handleBack}>
        <FaArrowLeft />
      </button>
      <div className="header">
        <h1>Room: {roomCode}</h1>
      </div>
      <div className="chat-container">
        <div className="messagesContainer">
          {messages.map((message, index) => (
            <div key={index} className="message">
              <a href={message.fileUrl} target="_blank" rel="noreferrer">
                Download File
              </a>
              <span>({new Date(message.timestamp).toLocaleString()})</span>
            </div>
          ))}
        </div>
      </div>
      <div className="input-container">
        <form onSubmit={sendMessage} className="fileInputContainer">
          <input type="file" id="fileInput" className="fileInput" />
          <label htmlFor="fileInput" className="fileInputLabel"><FaFileUpload /></label>
          <button type="submit" className="sendButton"><FaPaperPlane /></button>
        </form>
      </div>
      {isLoading && <LoadingPopup />} 
    </div>
  );
}

export default Room;
