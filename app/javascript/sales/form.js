import { showErrorMessage, removeErrorMessage, getDateSelectVal, checkLength, checkNumber, checkFuture, btnDisabled } from '../module/validation';
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('#sale_amount_sold,#sale_remark');
  
  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。');
        btnDisabled();
      }
    });
    
    input.addEventListener('input', () => {
      input.name === 'sale[remark]' && checkLength('備考', 1000, input);
      input.name === 'sale[amount_sold]' && checkNumber('販売価格', input);
      btnDisabled();
    });
  });
  
  // slimselectのイベント設定
  const slimSelects = document.querySelectorAll('select[data-controller="slim"]');
  slimSelects.forEach((select) => {
    select.addEventListener('change', () => {
      const nextDiv = select.nextElementSibling;
      
      if(select.options[0].selected === true){
        showErrorMessage(nextDiv, '※必須項目です。');
        btnDisabled();
      }else{
        removeErrorMessage(nextDiv);
        btnDisabled();
      }
    });
  });
  
  // selectのイベント設定
  const selects = document.querySelectorAll('select[name^="sale[created_at"]');
  const aaa = selects[0].parentElement.innerText
  selects.forEach((select) => {
    select.addEventListener('change', () => {
      const span = selects[selects.length - 1].nextElementSibling
      const createDate = getDateSelectVal(selects);
      
      checkFuture('登録日時', createDate, span);
      btnDisabled();
    });
  });
  
  toolTipAddEvent();
});