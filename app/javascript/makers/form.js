import { showErrorMessage } from '../form/validation';
import { checkLength } from '../form/validation';

document.addEventListener('turbo:load', () => {
  // inputのイベント設定
  const input = document.querySelector('#maker_name');
  input.addEventListener('blur', () => {
    if(input.hasAttribute('required') && input.value.trim() === '') {
      showErrorMessage(input, '※必須項目です。','input');
    }
  });

  input.addEventListener('input', () => {
    checkLength('メーカー名', 30, input);
  });
})