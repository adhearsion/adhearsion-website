window.onload = function() {
  loc = window.location.href;
  $("a[href*='/docs']").each(function() {
    if(this.href == loc) {
      $(this).css('font-weight', 'bold');
    }
  });
};