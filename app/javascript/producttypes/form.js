import { showErrorMessage, checkLength } from '../module/validation';

document.addEventListener('turbo:load', () => {
  const input = document.querySelector('#producttype_name');
  // inputのイベント設定
  input.addEventListener('blur', () => {
    if(input.hasAttribute('required') && input.value.trim() === '') {
      showErrorMessage(input, '※必須項目です。','input');
    }
  });

  input.addEventListener('input', () => {
    checkLength('商品分類名', 30, input);
  });
});