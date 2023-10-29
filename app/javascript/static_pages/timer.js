import { getDateString, getTimeString } from 'module/format'
document.addEventListener('turbo:load', () => {
  const dateDiv = document.getElementById('date');
  const timeDiv = document.getElementById('time');
  if(!dateDiv) return false;
  
  let newDate = null;
  const clock = () => {
    const now = new Date();
    // 日にちが変わったら、新しい日付をnewDateにセットし、要素に再出
    if( newDate !== now.getDate() ) {
        newDate = now.getDate();
        dateDiv.innerText = getDateString(now);
    }
    timeDiv.innerText = getTimeString(now);
  };
  // 初期表示のラグ対策
  clock();
  // 1秒ごとに実行
  setInterval(clock, 1000);
});