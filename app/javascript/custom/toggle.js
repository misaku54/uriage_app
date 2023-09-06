document.addEventListener('turbo: load', () => {
  const toggleMenu = document.querySelector('.toggle-menu');
  console.log('aa')
  toggleMenu.addEventListener('click', () => {
    toggleMenu.classList.toggle('open');
  })
})