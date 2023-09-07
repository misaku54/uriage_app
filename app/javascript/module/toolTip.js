export const mout = (element, popElement) => {
  element.addEventListener('mouseover', () => {
    popElement.style.display = 'block';
  });
  element.addEventListener('mouseleave', () => {
    popElement.style.display = 'none';
  });
}