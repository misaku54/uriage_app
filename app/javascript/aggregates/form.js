import { showErrorMessage, checkTime, btnDisabled } from '../module/validation';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('input[name^="search_daily["]');
  const parent = inputs[0].closest('.form_group');
  console.log(parent)

  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(parent, '※必須項目です。','input');
        btnDisabled();
      };
    });

    input.addEventListener('input', () => {
      const startInput = document.querySelector('input[name="search_daily[start_date]"]');
      const endInput   = document.querySelector('input[name="search_daily[end_date]"]');
      const startDate = new Date(startInput.value);
      const endDate   = new Date(endInput.value);
      
      checkTime(startDate, endDate, parent);
      btnDisabled();
    });
  })
})