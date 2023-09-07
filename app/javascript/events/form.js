import { showErrorMessage, checkLength, checkTime, btnDisabled } from '../module/validation';
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('#event_title,#event_content');
  const selects = document.querySelectorAll('select');
  
  // input textareaのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。','input');
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
  selects.forEach((select) => {
    select.addEventListener('change', () => {
      const startSelects = document.querySelectorAll('select[name^="event[start_time"]');
      const endSelects = document.querySelectorAll('select[name^="event[end_time"]');
      const parent = endSelects[0].parentElement; // エラーメッセージの表示場所を取得するために、selectの親要素を取得しておく。
      let dateAry = [];

      // セレクトボックスの開始時刻を取得
      startSelects.forEach((startSelect, index) => 
        (index === 1) ? dateAry.push(`${Number(startSelect.value) - 1}`) : dateAry.push(startSelect.value));
      const startTime = new Date(...dateAry);
      dateAry = [];

      // セレクトボックスの終了時刻を取得
      endSelects.forEach((endSelect, index) => 
        (index === 1) ? dateAry.push(`${Number(endSelect.value) - 1}`) : dateAry.push(endSelect.value));
      const endTime = new Date(...dateAry);

      checkTime(startTime, endTime, parent);
      btnDisabled();
    });
  });
  
  toolTipAddEvent();
});