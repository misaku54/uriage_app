const showErrorMessage = (target, message) => {
  if(!target.nextElementSibling) {
    const errorMessage = document.createElement('small');
    errorMessage.textContent = message;
    target.insertAdjacentElement("afterend", errorMessage);
  }
}

const removeErrorMessage = (target) => {
  const error = target.nextElementSibling;
  if(error){
    error.remove();
  }
}

const checkLength = (labelName, maxLength, input) => {
  if(input.value.length > maxLength) {
    showErrorMessage(input, `${labelName}は、${maxLength}文字以内にしてください`)
  }else{
    removeErrorMessage(input);
  }
}



const inputSelector = document.querySelectorAll('.input');
inputSelector[0].focus();
console.log(inputSelector)

for (const input of inputSelector) {
  input.addEventListener('blur', () => {
    if(input.hasAttribute('required') && input.value.trim() === ''){
      showErrorMessage(input, '必須項目です。');
    }
  });

  input.addEventListener('input', () => {
    console.log('aaa')
    input.name === 'maker[name]' && checkLength('メーカー名', 30, input);
    input.name === 'producttype[name]' && checkLength('商品分類名', 30, input);
  });
}