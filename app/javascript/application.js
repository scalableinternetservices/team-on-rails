// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load', function() {
  // Remove existing event listeners first
  const toggleButton = document.getElementById('toggle-search');
  const searchBar = document.getElementById('search-bar');
  const button1 = document.getElementById('show-interface-1');
  const button2 = document.getElementById('show-interface-2');
  const interface1 = document.getElementById('interface-1');
  const interface2 = document.getElementById('interface-2');
  const searchInput = document.getElementById('search-bar');
  const suggestions = document.getElementById('suggestions');

  // Clone and replace elements to remove existing listeners
  console.log(toggleButton)
  if (toggleButton) {
    console.log("toglge")

    const newToggleButton = toggleButton.cloneNode(true);
    toggleButton.parentNode.replaceChild(newToggleButton, toggleButton);
    newToggleButton.addEventListener('click', () => {
      const searchBar = document.getElementById('search-bar');
      searchBar.classList.toggle('active');
      searchBar.focus();
    });
    console.log("toglge")
  }

  if (button1 && button2) {
    const newButton1 = button1.cloneNode(true);
    const newButton2 = button2.cloneNode(true);
    button1.parentNode.replaceChild(newButton1, button1);
    button2.parentNode.replaceChild(newButton2, button2);

    newButton1.addEventListener('click', () => {
      interface1.classList.add('active1');
      interface2.classList.remove('active2');
      newButton1.classList.add('active');
      newButton2.classList.remove('active');
    });

    newButton2.addEventListener('click', () => {
      interface2.classList.add('active2');
      interface1.classList.remove('active1');
      newButton2.classList.add('active');
      newButton1.classList.remove('active');
    });
  }

  if (searchInput && suggestions) {
    const newSearchInput = searchInput.cloneNode(true);
    searchInput.parentNode.replaceChild(newSearchInput, searchInput);

    newSearchInput.addEventListener('input', async () => {
      const query = newSearchInput.value;
      const response = await fetch(`/search?query=${encodeURIComponent(query)}`, {
        headers: {
          'Accept': 'application/json'
        }
      });
      const data = await response.json();
      suggestions.innerHTML = data.map(item => 
        `<li data-username="${item}">${item}</li>`
      ).join('');
      suggestions.style.display = 'block';
    });

    console.log("searchInput")
    suggestions.addEventListener('click', (e) => {
    const item = e.target
    if (item) {
      const username = item.textContent;
      console.log("Selected username:", username); // Debug log
      newSearchInput.value = username;
      suggestions.style.display = 'none';
    }
  });
  }

  // Document click handler (only needs to be bound once)
  document.removeEventListener('click', documentClickHandler);
  document.addEventListener('click', documentClickHandler);
});

function documentClickHandler(e) {
  // Get fresh references inside the handler
  const suggestions = document.getElementById('suggestions');
  const searchBar = document.getElementById('search-bar');
  if (!e.target.closest('.form-group') && !e.target.closest('.plus-button')) {
    if (suggestions) suggestions.style.display = 'none';
    if (searchBar) searchBar.classList.remove('active');
  }
}