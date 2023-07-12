document.addEventListener('turbo:render', () => {
  const loading = document.querySelector('#loading');
  loading.classList.add('loaded');
});

document.addEventListener('turbo:load', () => {
  const loading = document.querySelector('#loading');
  loading.classList.add('loaded');
});