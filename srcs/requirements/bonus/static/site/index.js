document.addEventListener('DOMContentLoaded', function () {
  const items = document.querySelectorAll('.skills-prog li[data-percent]');
  items.forEach((li, idx) => {
    const pct = parseInt(li.getAttribute('data-percent'), 10) || 0;
    const bar = li.querySelector('.bar');
    if (!bar) return;
    bar.setAttribute('role', 'progressbar');
    bar.setAttribute('aria-valuemin', '0');
    bar.setAttribute('aria-valuemax', '100');
    bar.setAttribute('aria-valuenow', String(pct));

    // add percent text element
    const label = document.createElement('span');
    label.textContent = pct + '%';
    label.setAttribute('aria-hidden', 'true');

    bar.textContent = '';
    bar.appendChild(label);
    bar.getBoundingClientRect();

    // animation for width
    setTimeout(() => {
      bar.style.width = pct + '%';
    }, idx * 120);
  });
});