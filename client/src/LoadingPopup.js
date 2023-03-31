import { FaSpinner } from 'react-icons/fa';
import './LoadingPopup.css';

function LoadingPopup() {
  return (
    <div className="loading-popup">
      <div className="loading-icon">
        <FaSpinner />
      </div>
      <div className="loading-text">Loading...</div>
    </div>
  );
}

export default LoadingPopup;
