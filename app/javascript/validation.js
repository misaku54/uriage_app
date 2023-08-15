export const showErrorMessage = (target, message) => {
  const errorMessage = document.createElement('p');
  errorMessage.textContent = message;
  
  if(!target.nextElementSibling) {
    target.insertAdjacentElement("afterend", errorMessage);
  }
}

export const removeErrorMessage = (target) => {
  const error = target.nextElementSibling;
  if(error){
    error.remove();
  }
}

export const checkLength = (labelName, maxLength, input) => {
  if(input.value.length > maxLength) {
    showErrorMessage(input, `${labelName}は、${maxLength}文字以内にしてください`)
  }else{
    removeErrorMessage(input);
  }
}