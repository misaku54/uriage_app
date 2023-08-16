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
      target.parentElement.insertAdjacentElement('beforeend', errorMessage);
      break;
      
    default:
      console.log('その他');
  }
}

const removeErrorMessage = (target, type) => {
  switch(type) {
    case 'input':
      const error = target.nextElementSibling;
      if(error) {
        error.remove();
      }
      break;
    
    case 'slim':
      const selectError = target.parentElement
      if(selectError.classList.contains('invalid')) {
        selectError.remove();
      }

    default:
      console.log('その他');
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
        showErrorMessage(input, '必須項目です。','input');
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
      showErrorMessage(select, '必須項目です。', 'slim')
    }else{
      console.log('bnot')
      removeErrorMessage(select, parent)
    }
  })
}