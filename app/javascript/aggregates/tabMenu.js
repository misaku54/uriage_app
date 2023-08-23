document.addEventListener('turbo:load',() => {
  
  const tabs = document.querySelectorAll('#tab');
  const switchElementClass = (e) => {
    const targetEl = e.target.getAttribute('href')
  }

  // 要素がなければ終了
  if(!tabs.length){ return 0 }


  tabs.forEach((tab) => {
    tab.addEventListener('click', switchElementClass)
  })
  
  
  console.log('終了')
})