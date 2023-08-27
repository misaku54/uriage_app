import  { zeroPadding } from './home.js'
// グローバルスコープ
const currTempDiv    = document.querySelector('.current-temperature');
const currWeatherDiv = document.querySelector('.current-weather');
const currRainSpan   = document.querySelector('.current-rainfall');
const maxTempSpan    = document.querySelector('.max-temperature');
const minTempSpan    = document.querySelector('.min-temperature');

// dateオブジェクト整形用の関数
const getDateSting = date => 
  `${zeroPadding(date.getFullYear())}-${zeroPadding(date.getMonth() + 1)}-${zeroPadding(date.getDate())}`;

// weatherAPI呼び出し 
const callApi = async () => {
  const now = new Date()
  const today = getDateSting(now);
  const hour = now.getHours();
  const res  = await fetch(`https://api.open-meteo.com/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=Asia%2FTokyo&start_date=${today}&end_date=${today}`)
  const data = await res.json();
  currTempDiv.innerText     = data.hourly.temperature_2m[hour]
  currWeatherDiv.innerText  = data.hourly.weathercode[hour]
  currRainSpan.innerText = data.hourly.precipitation_probability[hour]
  maxTempSpan.innerText  = data.daily.temperature_2m_max[0]
  minTempSpan.innerText  = data.daily.temperature_2m_min[0]
}

document.addEventListener('turbo:load', () => {
  if(!currTempDiv){ return 0 };
  callApi();
  // 1時間ごとに実行
  setInterval(callApi, 3600000)
});