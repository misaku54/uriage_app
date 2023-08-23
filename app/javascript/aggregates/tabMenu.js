document.addEventListener('turbo:load',() => {
  const removeClass = (tab, item) => {
    const currentTab = tab.parentNode.querySelector('.current');
    const activeItem = item.parentNode.querySelector('.active');
    currentTab.classList.remove('current');
    activeItem.classList.remove('active');
  };

  const addClass = (tab, item) => {
    tab.classList.add('current');
    item.classList.add('active');
  };

  const switchElementClass = (e) => {
    const targetTab  = e.target;
    const targetItem = document.querySelector(e.target.getAttribute('href'));
    // 引数の親要素からcurrent、activeクラスを検索し削除する。
    removeClass(targetTab, targetItem);
    // 引数の要素にcurrent、activeクラスを付与する。
    addClass(targetTab, targetItem);
  };

  const tabs = document.querySelectorAll('#tab');
  // 要素がなければ終了
  if(!tabs.length){ return 0 };
  tabs.forEach((tab) => {
    tab.addEventListener('click', switchElementClass);
  });
});