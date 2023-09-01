export const dayOfWeek = ['日', '月', '火', '水', '木', '金', '土'];

// ゼロ埋め
export const zeroPadding = n => ( n < 10 ) ? '0' + n.toString() : n.toString();

// データオブジェクトを「yyyy年mm月dd日(曜日)」へ整形
export const getDateString = date => 
  `${zeroPadding(date.getFullYear())}年${zeroPadding(date.getMonth() + 1)}月${zeroPadding(date.getDate())}日(${dayOfWeek[date.getDay()]})`;

// データオブジェクトを「hh:mm:ss」へ整形
export const getTimeString = date =>
  `${zeroPadding(date.getHours())}:${zeroPadding(date.getMinutes())}:${zeroPadding(date.getSeconds())}`;


