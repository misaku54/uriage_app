// バリデーションエラーの表示
export const showErrorMessage = (element, message ,type) => {
  const errorMessage = document.createElement('div');
  errorMessage.textContent = message;
  errorMessage.classList.add('invalid');

  switch(type) {
    // typeがinputなら要素の真下にエラーメッセージを追加
    case "input":
      if(!element.nextElementSibling) {
        element.insertAdjacentElement('afterend', errorMessage);
      }
      break;
    // typeがselectなら要素の内側にエラーメッセージを追加
    case "select":
      if(!element.lastElementChild.classList.contains('invalid')){
        element.insertAdjacentElement('beforeend', errorMessage);
      }
      break;
    default:
      throw 'argument error';
  }
};

// バリデーションエラーの削除
export const removeErrorMessage = (element, type) => {
  switch(type) {
    // typeがinputなら要素の真下にあるエラーメッセージを削除
    case 'input':
      const error = element.nextElementSibling;
      if(error) {
        error.remove();
      }
      break;
    // typeがselectなら要素の内側にあるエラーメッセージを削除
    case 'select':
      const selectError = element.lastElementChild;
      if(selectError.classList.contains('invalid')) {
        selectError.remove();
      }
      break;
    default:
      throw 'argument error';
  }
};

// submitボタンの非活性
export const btnDisabled = () => {
  const btn = document.querySelector('input[type="submit"]');
  const invalidDivs = document.querySelectorAll('div.invalid');

  if(invalidDivs.length > 0) {
    btn.disabled = true;
  }else{
    btn.disabled = false;
  }
};

// 桁数チェック
export const checkLength = (labelName, maxLength, element) => {
  if(element.value.length > maxLength) {
    showErrorMessage(element, `※${labelName}は、${maxLength}文字以内にしてください`, 'input')
  }else{
    removeErrorMessage(element, 'input');
  }
};

// 数値の有効チェック
export const checkNumber = (labelName, element) => {
  // const regex = /^[1-9][0-9]+/;
  // const result = input.value.match(regex)
  if(element.value && element.value <= 0){
    showErrorMessage(element, `※${labelName}は、0より大きい数値を入力をしてください。`, 'input')
  }else{
    removeErrorMessage(element, 'input');
  }
};

// 日付の未来日チェック
export const checkFuture = (labelName, date, element) => {
  const now = new Date();
  if(date > now){
    showErrorMessage(element, `※${labelName}に、未来日は設定できません。`, 'select');
  }else{
    removeErrorMessage(element, 'select');
  }
};

// 開始時刻と終了時刻の矛盾チェック
export const checkTime = (start, end, element) => {
  if(start > end){
    showErrorMessage(element, `※終了時刻は開始時刻より前の日を設定することはできません。`, 'select');
  }else{
    removeErrorMessage(element, 'select');
  }
};