// dateオブジェクト整形用の変数と関数
const dayOfWeek = ['日', '月', '火', '水', '木', '金', '土'];

const getDateString = date => 
  `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日(${dayOfWeek[date.getDay()]})`;

const getTimeString = date =>
  `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;


// 画面ロード後の処理
document.addEventListener('turbo:load', () => {
  const dateDiv = document.getElementById('date');
  const timeDiv = document.getElementById('time');
  // 初期化
  let newDate = null;

  // 1秒ごとに実行
  setInterval(() => {
    // 現在の日付をコンストラクタで取得
    const now = new Date;
    // 日にちが変わったら、新しい日付をnewDateにセットし、要素に再出力
    if( newDate !== now.getDate() ) {
        newDate = now.getDate();
        dateDiv.innerText = getDateString(now);
    }
    timeDiv.innerText = getTimeString(now);
  }, 1000);
});