// バリデーションエラーの表示
export const showErrorMessage = (target, message ,type) => {
  const errorMessage = document.createElement('div');
  errorMessage.textContent = message;
  errorMessage.classList.add('invalid');

  switch(type) {
    case "input":
      if(!target.nextElementSibling) {
        target.insertAdjacentElement('afterend', errorMessage);
      }
      break;
    case "select":
      if(!target.lastElementChild.classList.contains('invalid')){
        target.insertAdjacentElement('beforeend', errorMessage);
      }
      break;
    default:
      throw 'argument error';
  }
};

// バリデーションエラーの削除
export const removeErrorMessage = (target, type) => {
  switch(type) {
    case 'input':
      const error = target.nextElementSibling;
      if(error) {
        error.remove();
      }
      break;
    case 'select':
      const selectError = target.lastElementChild;
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
export const checkLength = (labelName, maxLength, input) => {
  if(input.value.length > maxLength) {
    showErrorMessage(input, `※${labelName}は、${maxLength}文字以内にしてください`, 'input')
  }else{
    removeErrorMessage(input, 'input');
  }
};

// 数値の有効チェック
export const checkNumber = (labelName, input) => {
  // const regex = /^[1-9][0-9]+/;
  // const result = input.value.match(regex)
  if(input.value && input.value <= 0){
    showErrorMessage(input, `※${labelName}は、0より大きい数値を入力をしてください。`, 'input')
  }else{
    removeErrorMessage(input, 'input');
  }
};

// 日付の未来日チェック
export const checkFuture = (labelName, date, input) => {
  const now = new Date();
  if(date > now){
    showErrorMessage(input, `※${labelName}に、未来日は設定できません。`, 'select');
  }else{
    removeErrorMessage(input, 'select');
  }
};

// 開始時刻と終了時刻の矛盾チェック
export const checkTime = (startTime, endTime, parent) => {
  if(startTime > endTime){
    showErrorMessage(parent, `※終了時刻は開始時刻より前の日を設定することはできません。`, 'select');
  }else{
    removeErrorMessage(parent, 'select');
  }
};