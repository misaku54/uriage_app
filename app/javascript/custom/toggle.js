document.addEventListener('turbo:load', () => {
  const humbager   = document.querySelector('.humbager');
  const toggleMenu = document.querySelector('.toggle-menu');
  humbager.addEventListener('click', () => {
    toggleMenu.classList.toggle('open');
  })
})