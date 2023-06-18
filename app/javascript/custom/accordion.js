// const acc_ttl=Array.from(document.querySelectorAll(".accordion__ttl"));

// for(let i=0; i< acc_ttl.length; i++){
//   let ttl=acc_ttl[i];
//   let content=ttl.nextElementSibling;
//   ttl.addEventListener("click",()=>{
//     ttl.classList.toggle("is-active");
//     if (content.style.height) {
//       content.style.height = null;
//     } else {
//       content.style.height = content.scrollHeight + 'px';
//     }
//   });
// }
// 新しい配列を作成
document.addEventListener("turbo:load", () => {
  const acc_ttls = document.querySelectorAll('.acordion__ttl');
  console.log('aaaaa')
  for(let i = 0; i < acc_ttls.length; i++){
    let ttl = acc_ttls[i];
    let content = ttl.nextElementSibling;
    ttl.addEventListener('click', () => {
      ttl.classList.toggle('is-active');

      // コンテンツの高さがあれば、高さを０に
      if (content.style.height) {
        content.style.height = null;
      } else {
        content.style.height = content.scrollHeight + 'px';
      }
    });
  }
});