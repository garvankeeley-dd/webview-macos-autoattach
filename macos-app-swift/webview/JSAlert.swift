import Foundation

func jsAlert(message: String) -> String {
    """
    // Function to show overlay alert
    function showOverlayAlert(message) {
      // Create overlay div
      const overlay = document.createElement('div');
      overlay.id = 'overlay-alert';
      overlay.style.position = 'fixed';
      overlay.style.top = '0';
      overlay.style.left = '0';
      overlay.style.width = '100%';
      overlay.style.height = '100%';
      overlay.style.zIndex = '1000';
      overlay.style.display = 'flex';
      overlay.style.justifyContent = 'center';
      overlay.style.alignItems = 'center';
      overlay.style.background = 'rgba(0, 0, 0, 0.5)';
      overlay.style.color = 'white';
      overlay.style.fontSize = '18px';
      overlay.style.padding = '20px';
      overlay.style.textAlign = 'center';

      // Create alert message div
      const alertMessage = document.createElement('div');
      alertMessage.textContent = message;
      alertMessage.style.width = '300px';
      alertMessage.style.height = '200px';
      alertMessage.style.background = 'white';
      alertMessage.style.color = 'black';
      alertMessage.style.padding = '20px';

      // Append alert message to overlay
      overlay.appendChild(alertMessage);

      // Append overlay to body
      document.body.appendChild(overlay);

      // Hide overlay after 3 seconds
        //      setTimeout(() => {
        //        overlay.remove();
        //      }, 10000);
    }

    // Show overlay alert
    showOverlayAlert('\(message)');
    """
}
