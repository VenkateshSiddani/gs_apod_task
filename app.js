// NASA APOD API configuration
const API_KEY = 'DEMO_KEY'; // Replace with your NASA API key from https://api.nasa.gov/
const BASE_URL = 'https://api.nasa.gov/planetary/apod';

// DOM element references
const datePicker = document.getElementById('date-picker');
const fetchBtn = document.getElementById('fetch-btn');
const errorMessage = document.getElementById('error-message');
const loading = document.getElementById('loading');
const apodContainer = document.getElementById('apod-container');
const apodTitle = document.getElementById('apod-title');
const apodDate = document.getElementById('apod-date');
const mediaContainer = document.getElementById('media-container');
const apodExplanation = document.getElementById('apod-explanation');
const apodCopyright = document.getElementById('apod-copyright');

/**
 * Returns today's date formatted as YYYY-MM-DD.
 * @returns {string}
 */
function getTodayDate() {
  const today = new Date();
  const year = today.getFullYear();
  const month = String(today.getMonth() + 1).padStart(2, '0');
  const day = String(today.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/**
 * Shows an error message to the user.
 * @param {string} message
 */
function showError(message) {
  errorMessage.textContent = message;
  errorMessage.classList.remove('hidden');
  apodContainer.classList.add('hidden');
  loading.classList.add('hidden');
}

/**
 * Clears any displayed error message.
 */
function clearError() {
  errorMessage.textContent = '';
  errorMessage.classList.add('hidden');
}

/**
 * Renders the APOD data into the page.
 * @param {Object} data - APOD API response object
 */
function renderApod(data) {
  apodTitle.textContent = data.title || 'Untitled';
  apodDate.textContent = `Date: ${data.date}`;
  apodExplanation.textContent = data.explanation || '';
  apodCopyright.textContent = data.copyright
    ? `© ${data.copyright.trim()}`
    : '';

  mediaContainer.innerHTML = '';

  if (data.media_type === 'video') {
    const iframe = document.createElement('iframe');
    iframe.src = data.url;
    iframe.title = data.title;
    iframe.allowFullscreen = true;
    iframe.setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture');
    mediaContainer.appendChild(iframe);
  } else {
    const img = document.createElement('img');
    img.src = data.hdurl || data.url;
    img.alt = data.title;
    img.loading = 'lazy';
    mediaContainer.appendChild(img);
  }

  apodContainer.classList.remove('hidden');
  loading.classList.add('hidden');
}

/**
 * Fetches the APOD data for the given date from the NASA API.
 * @param {string} date - Date string in YYYY-MM-DD format
 */
async function fetchApod(date) {
  clearError();
  apodContainer.classList.add('hidden');
  loading.classList.remove('hidden');
  fetchBtn.disabled = true;

  const url = `${BASE_URL}?api_key=${API_KEY}&date=${date}`;

  try {
    const response = await fetch(url);

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      const message =
        errorData.msg ||
        errorData.error?.message ||
        `Request failed with status ${response.status}.`;
      throw new Error(message);
    }

    const data = await response.json();
    renderApod(data);
  } catch (error) {
    if (error.name === 'TypeError') {
      showError('Network error. Please check your internet connection and try again.');
    } else {
      showError(`Error: ${error.message}`);
    }
  } finally {
    fetchBtn.disabled = false;
  }
}

// Initialise the date picker to today and load today's APOD on page load
datePicker.value = getTodayDate();
datePicker.max = getTodayDate();

fetchBtn.addEventListener('click', () => {
  const selectedDate = datePicker.value;
  if (!selectedDate) {
    showError('Please select a date.');
    return;
  }
  fetchApod(selectedDate);
});

// Load today's APOD automatically when the page opens
fetchApod(getTodayDate());
