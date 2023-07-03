import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
  },

  disconnected() {
  },

  // Show data to the user in the prepared divs
  received(data) {
    var cachedLabel = document.querySelector('.alert-info');
    // Hide the cached label
    cachedLabel.classList.add('d-none')

    var forecastResults = document.querySelector('.forecast-results');
    // Show data as it is
    forecastResults.innerHTML = data.message;

    if (data.cached == true) {
      // Show the cached label
      cachedLabel.classList.remove('d-none')
    }
  }
});
