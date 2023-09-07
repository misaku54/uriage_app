// ツールチップイベント
export const toolTipAddEvent = () => {
  const toolTips = document.querySelectorAll('.tooltip-block');

  toolTips.forEach(toolTip => {
    const toolTipText = toolTip.querySelector('.tooltip-text');
    const toolTipBtn  = toolTip.querySelector('.tooltip-btn');

    toolTipBtn.addEventListener('mouseover', () => {
      toolTipText.style.display = 'block';
    });
    toolTipBtn.addEventListener('mouseleave', () => {
      toolTipText.style.display = 'none';
    });
  });
}