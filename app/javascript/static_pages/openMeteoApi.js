import  { getDateStringShort } from '../module/format'

const currTempDiv    = document.querySelector('#current-temperature');
const currWeatherDiv = document.querySelector('#current-weather');
const currRainSpan   = document.querySelector('#current-rainfall');
const maxTempSpan    = document.querySelector('#max-temperature');
const minTempSpan    = document.querySelector('#min-temperature');

// 天気情報の取得
const getWeather = code => {
  if(code !== 0 && !code){ return "不明" };
  if(code == 0) { return "快晴\u{2600}" };
  if(code == 1) { return "晴れ\u{2600}" };
  if(code == 2) { return "一部曇\u{1F324}" };
  if(code == 3) { return "曇り\u{2601}" };
  if(code <= 49){ return "霧\u{1F32B}" };
  if(code <= 59){ return "霧雨\u{1F32B}" };
  if(code <= 69){ return "雨\u{1F327}" };
  if(code <= 79){ return "雪\u{26C4}" };
  if(code <= 84){ return "俄か雨\u{1F327}" };
  if(code <= 94){ return "雪・雹\u{2603}" };
  if(code <= 99){ return "雷雨\u{26C8}" };
  return "不明"
};

// weatherAPI呼び出し 
const callApi = async () => {
  const now = new Date()
  const today = getDateStringShort(now);
  const hour = now.getHours();
  // API取得
  try {
    const res  = await fetch(`https://api.open-meteo.com/v1/forecast?latitude=31.9167&longitude=131.4167&hourly=temperature_2m,precipitation_probability,precipitation_probability,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=Asia%2FTokyo&start_date=${today}&end_date=${today}`)
    const data = await res.json();
    currTempDiv.innerText    = `${data.hourly.temperature_2m[hour]}°C`;
    currWeatherDiv.innerText = getWeather(data.hourly.weathercode[hour]);
    currRainSpan.innerText   = `${data.hourly.precipitation_probability[hour]}%`;
    maxTempSpan.innerText    = `${data.daily.temperature_2m_max[0]}°C`;
    minTempSpan.innerText    = `${data.daily.temperature_2m_min[0]}°C`;
  } catch (e) {
    console.error(e);
    currTempDiv.innerText    = "-°C";
    currWeatherDiv.innerText = "-";
    currRainSpan.innerText   = "-%";
    maxTempSpan.innerText    = "-°C";
    minTempSpan.innerText    = "-°C";
  }
}

document.addEventListener('turbo:load', () => {
  callApi();
  // 1時間ごとに実行
  setInterval(callApi, 3600000);
});