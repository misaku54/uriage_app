import { showErrorMessage, removeErrorMessage, checkLength, checkNumber, checkFuture, btnDisabled } from '../module/validation';
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('#sale_amount_sold,#sale_remark');
  const slimSelects = document.querySelectorAll('.slim-select');
  const selects = document.querySelectorAll('select[name^="sale[created_at"]');

  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。','input');
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
  slimSelects.forEach((select) => {
    const parent = select.parentElement; // エラーメッセージの表示場所を取得するために、selectの親要素を取得しておく。

    select.addEventListener('change', () => {
      if(select.options[0].selected === true){
        showErrorMessage(parent, '※必須項目です。', 'select');
        btnDisabled();
      }else{
        removeErrorMessage(parent, 'select');
        btnDisabled();
      }
    });
  });

  // selectのイベント設定
  selects.forEach((select) => {
    const parent = selects[0].parentElement; // エラーメッセージの表示場所を取得するために、selectの親要素を取得しておく。

    select.addEventListener('change', () => {
      const dateAry = [];
      // セレクトボックスの登録日時を取得
      selects.forEach((element, index) => 
        (index === 1) ? dateAry.push(`${Number(element.value) - 1}`) : dateAry.push(element.value));
      const createDate = new Date(...dateAry);

      checkFuture('登録日時', createDate, parent);
      btnDisabled();
    });
  });
  toolTipAddEvent();
});