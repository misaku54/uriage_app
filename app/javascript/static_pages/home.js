// dateオブジェクト整形用の変数と関数
const dayOfWeek = ['日', '月', '火', '水', '木', '金', '土'];
const zeroPadding = n => ( n < 10 ) ? '0' + n.toString() : n.toString();

const getDateString = date => 
  `${zeroPadding(date.getFullYear())}年${zeroPadding(date.getMonth() + 1)}月${zeroPadding(date.getDate())}日(${dayOfWeek[date.getDay()]})`;

const getTimeString = date =>
  `${zeroPadding(date.getHours())}:${zeroPadding(date.getMinutes())}:${zeroPadding(date.getSeconds())}`;

document.addEventListener('turbo:load', () => {
  const dateDiv = document.getElementById('date');
  const timeDiv = document.getElementById('time');
  let newDate = null;
  const clock = () => {
    const now = new Date();
    // 日にちが変わったら、新しい日付をnewDateにセットし、要素に再出力
    if( newDate !== now.getDate() ) {
        newDate = now.getDate();
        dateDiv.innerText = getDateString(now);
    }
    timeDiv.innerText = getTimeString(now);
  };

  // 要素があった場合に実行
  if( dateDiv && timeDiv ){
    // 初期表示のラグ対策
    clock();
    // 1秒ごとに実行
    setInterval(clock, 1000);
  };
});