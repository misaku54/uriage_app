document.addEventListener("turbo:load", function() {
  const overlay = document.querySelector('.overlay');
  const modal   = document.querySelector('.modal-window');
  const btn     = document.querySelector('.modal-btn');

  btn.addEventListener('click', () => {
    overlay.classList.toggle('overlay_isOpen');
    modal.classList.toggle('modal_isOpen');
    document.body.style.overflowY = 'hidden';
  });
});