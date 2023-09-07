import { showErrorMessage, removeErrorMessage, checkLength, checkNumber, checkFuture, btnDisabled } from '../module/validation';
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('#user_name, #user_email, #user_password, #user_password_confirmation');

  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。','input');
        btnDisabled();
      }
    });

    input.addEventListener('input', () => {
      input.name === 'user[name]' && checkLength('ユーザー名', 30, input);
      input.name === 'user[email]' && checkLength('アドレス', 255, input);
      btnDisabled();
    });
  });

  // toolTipAddEvent();
});