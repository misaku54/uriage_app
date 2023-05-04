document.addEventListener("turbo:load", function() {
  const overlay = document.querySelector('.overlay');
  const modal   = document.querySelector('.modal-window');
  const btn     = document.querySelector('#add-maker');
  const btnClose  = document.querySelector('#close');

  const toggleModal = () =>{
    overlay.classList.toggle('overlay_isOpen');
    modal.classList.toggle('modal_isOpen');
  };

  btn.addEventListener('click', () => {
    toggleModal();
    document.body.style.overflowY = 'hidden';
  });

  btnClose.addEventListener('click', () => {
    toggleModal();
    document.body.style.overflowY = 'auto';
  });

});