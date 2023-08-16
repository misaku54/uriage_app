// 関数部---------------------------------------------------------
// バリデーションエラーの表示
const showErrorMessage = (target, message ,type) => {
  const errorMessage = document.createElement('small');
  errorMessage.textContent = message;
  errorMessage.classList.add('invalid');

  switch(type) {
    case "input":
      if(!target.nextElementSibling) {
        target.insertAdjacentElement('afterend', errorMessage);
      }
      break;

    case "slim":
      target.insertAdjacentElement('beforeend', errorMessage);
      break;
      
    default:
      throw 'argument error';
  }
}

// バリデーションエラーの削除
const removeErrorMessage = (target, type) => {
  switch(type) {
    case 'input':
      const error = target.nextElementSibling;

      if(error) {
        error.remove();
      }
      break;

    case 'slim':
      const slimError = target.lastElementChild;

      if(slimError.classList.contains('invalid')) {
        slimError.remove();
      }
      break;

    default:
      throw 'argument error';
  }
}

// 桁数チェック
const checkLength = (labelName, maxLength, input) => {
  if(input.value.length > maxLength) {
    showErrorMessage(input, `※${labelName}は、${maxLength}文字以内にしてください`, 'input')
  }else{
    removeErrorMessage(input, 'input');
  }
}

// 数値の有効チェック
const checkNumber = (labelName, input) => {
  // const regex = /^[1-9][0-9]+/;
  // const result = input.value.match(regex)
  if(input.value && input.value <= 0){
    showErrorMessage(input, `※${labelName}は、0より大きい数値を入力をしてください。`, 'input')
  }else{
    removeErrorMessage(input, 'input')
  }

}


// 実行部---------------------------------------------------------
// input系のバリデーションイベント
const inputSelector = document.querySelectorAll('.input');
if(inputSelector) {
  for (const input of inputSelector) {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === ''){
        showErrorMessage(input, '※必須項目です。','input');
      }
    });

    input.addEventListener('input', () => {
      input.name === 'maker[name]' && checkLength('メーカー名', 30, input);
      input.name === 'producttype[name]' && checkLength('商品分類名', 30, input);
      input.name === 'sale[remark]' && checkLength('備考', 1000, input);
      input.name === 'sale[amount_sold]' && checkNumber('販売価格', input);
    });
  }
}

// slimselectのバリデーションイベント
const selectBox = document.querySelectorAll('.selectBox');
if(selectBox) {
  for (const select of selectBox) {
    const parent = select.parentElement

    select.addEventListener('change', () => {
      if(select.options[0].selected === true){
        showErrorMessage(parent, '※必須項目です。', 'slim');
      }else{
        removeErrorMessage(parent, 'slim');
      }
    });
  }
}