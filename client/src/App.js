import React from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Room from './Room';
import Main from './Main';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Main />} />
        <Route path="/rooms/:roomCode" element={<Room />} />
      </Routes>
    </Router>
  );
}

export default App;
