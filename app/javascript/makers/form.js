import { showErrorMessage, checkLength } from '../form/validation';

document.addEventListener('turbo:load', () => {
  const input = document.querySelector('#maker_name');

  // inputのイベント設定
  input.addEventListener('blur', () => {
    if(input.hasAttribute('required') && input.value.trim() === '') {
      showErrorMessage(input, '※必須項目です。','input');
    };
  });
  
  input.addEventListener('input', () => {
    checkLength('メーカー名', 30, input);
  });
})