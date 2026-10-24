(() => {
  const button = document.getElementById('lang-toggle');
  const switchLanguage = () => {
    const isEnglish = document.documentElement.lang !== 'zh-CN';
    document.documentElement.lang = isEnglish ? 'zh-CN' : 'en';
    document.title = isEnglish ? 'Agumuzi — 独立软件作品' : 'Agumuzi — Independent software';
    button.setAttribute('aria-label', isEnglish ? 'Switch to English' : '切换为中文');
  };
  if (button) button.addEventListener('click', switchLanguage);
})();