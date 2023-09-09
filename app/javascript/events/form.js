import { showErrorMessage, checkLength, getDateSelectVal, checkTime, btnDisabled } from '../module/validation';
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  // input textareaのイベント設定
  const inputs = document.querySelectorAll('#event_title,#event_content');
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。');
        btnDisabled();
      };
    });
    
    input.addEventListener('input', () => {
      input.name === 'event[title]' && checkLength('タイトル', 30, input);
      input.name === 'event[content]' && checkLength('内容', 1000, input);
      btnDisabled();
    });
  });
  
  // selectのイベント設定
  const selects = document.querySelectorAll('select');
  selects.forEach((select) => {
    select.addEventListener('change', () => {
      const startSelects = document.querySelectorAll('select[name^="event[start_time"]');
      const endSelects   = document.querySelectorAll('select[name^="event[end_time"]');
      const spanEl       = endSelects[endSelects.length - 1].nextElementSibling;
      const startDate = getDateSelectVal(startSelects);
      const endDate   = getDateSelectVal(endSelects);

      checkTime(startDate, endDate, spanEl);
      btnDisabled();
    });
  });
  
  toolTipAddEvent();
});