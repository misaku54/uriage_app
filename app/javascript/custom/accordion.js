document.addEventListener("turbo:load", () => {
  const acc_ttls = document.querySelectorAll('.acordion__ttl');
  console.log('load')
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

// document.addEventListener("turbo:render", () => {
//   console.log('render')
//   const acc_ttls = document.querySelectorAll('.acordion__ttl');
//   for(let i = 0; i < acc_ttls.length; i++){
//     let ttl = acc_ttls[i];
//     let content = ttl.nextElementSibling;
//     ttl.addEventListener('click', () => {
//       ttl.classList.toggle('is-active');

//       // コンテンツの高さがあれば、高さを０に
//       if (content.style.height) {
//         content.style.height = null;
//       } else {
//         content.style.height = content.scrollHeight + 'px';
//       }
//     });
//   }
// });