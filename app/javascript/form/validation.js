const showErrorMessage = (target, message , parent = null) => {
  console.log(target.nextElementSibling)
  const errorMessage = document.createElement('small');
  errorMessage.textContent = message;

  if(!target.nextElementSibling) {
    target.insertAdjacentElement('afterend', errorMessage);
  }
  if(parent){
    parent.insertAdjacentElement('beforeend', errorMessage);
  }
}

const removeErrorMessage = (target, parent = null) => {
  const error = target.nextElementSibling;
  const parent = parent.lastElementChild.classList.contain('samll') || null
  if(error){
    error.remove();
  }
  if(parent){
    parent.insertAdjacentElement('beforeend', errorMessage);
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
if(inputSelector) {
  // inputSelector[0].focus();
  console.log(inputSelector)

  for (const input of inputSelector) {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === ''){
        showErrorMessage(input, '必須項目です。');
      }
    });

    input.addEventListener('input', () => {
      input.name === 'maker[name]' && checkLength('メーカー名', 30, input);
      input.name === 'producttype[name]' && checkLength('商品分類名', 30, input);
    });
  }
}


const selectBox = document.querySelectorAll('.selectBox')

console.log(selectBox);

for (const select of selectBox) {
  const parent = select.parentElement
  console.log(parent)
  // select.options[0].selected === true && console.log('irero!')
  select.addEventListener('change', () => {
    if(select.options[0].selected === true){
      console.log('saaaa')
      showErrorMessage(select, '必須項目です。', parent)
    }else{
      removeErrorMessage(select, '必須項目です。', parent)
    }
  })
}