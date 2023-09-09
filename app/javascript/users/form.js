import { showErrorMessage, removeErrorMessage, checkLength, checkRegExp, checkMinLength, btnDisabled } from '../module/validation';
import { emailFormat } from '../module/format'
import { toolTipAddEvent } from '../module/toolTip';

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('#user_name, #user_email, #user_password, #user_password_confirmation');

  // inputのイベント設定
  inputs.forEach((input) => {
    input.addEventListener('blur', () => {
      if(input.hasAttribute('required') && input.value.trim() === '') {
        showErrorMessage(input, '※必須項目です。');
        btnDisabled();
      }else{
        input.name === 'user[email]' && checkRegExp('入力したアドレスは不正な値です。＠や.のつけ忘れがないか確認してください。', emailFormat ,input);
        btnDisabled();
      }
    });

    input.addEventListener('input', () => {
      input.name === 'user[name]' && checkLength('ユーザー名', 30, input);
      input.name === 'user[email]' && checkLength('アドレス', 255, input);
      input.name === 'user[password]' && checkMinLength('パスワード', 6, input);
      input.name === 'user[password_confirmation]' && removeErrorMessage(input);
      btnDisabled();
    });
  });

  toolTipAddEvent();
});