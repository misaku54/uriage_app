import { checkTime, btnDisabled } from 'module/validation';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('input[name^="search_daily["]');

  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('input', () => {
      const startInput = document.querySelector('input[name="search_daily[start_date]"]');
      const endInput   = document.querySelector('input[name="search_daily[end_date]"]');
      const startDate = new Date(startInput.value);
      const endDate   = new Date(endInput.value);
      const parent = endInput.parentNode;
      
      checkTime(startDate, endDate, parent);
      btnDisabled();
    });
  })
})