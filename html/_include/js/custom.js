jQuery(document).ready(function() {
          // Jquery Tools Tabs
          $("ul.tabs").tabs("div.panes > div");
          $("ul.css-tabs").tabs("div.css-panes > div");
          // Jquery Tools Scrollable
          $(".scrollable").scrollable();
          // Jquery Tools Accordions
          $(".accordion").tabs(".pane", {tabs: 'h2', effect: 'slide'});
          $(".accordion-faq").tabs(".pane", {tabs: 'span', effect: 'slide'});
          // Optional Image Captions
     	  $('img.captify').captify({});
          // External links open in new windows
          $("a[rel='external']").bind("click.external", function(){  window.open(this.href);  return false;  });
          // PrettyPhoto trigger rel
          $("a[rel^='prettyPhoto']").prettyPhoto();
          // Twitter Js
          $(".tweet").tweet({
            join_text: "auto",
            username: "bogdanspn",
            avatar_size: 0,
            count: 2,
            auto_join_text_default: "we said,",
            auto_join_text_ed: "we",
            auto_join_text_ing: "we were",
            auto_join_text_reply: "we replied",
            auto_join_text_url: "we were checking out",
            loading_text: "Loading tweets..."
          });
          // Pricing Movements
          /* $(function() {
          $("ul.pricing-col").mouseover(function(){
          $(this).removeClass().addClass("pricing-col-highlight");
          }).mouseout(function(){
          $(this).removeClass().addClass("pricing-col");
          })}); */
});

// simple hide no animation
function hide(id){  if (document.getElementById){  obj = document.getElementById(id);  obj.style.display = "none";  } }

// simple show no animation
function show(id){  if (document.getElementById){  obj = document.getElementById(id);  obj.style.display = ""; } }

// jquery hide, show and toggle
function ajaxshow(id){	$(id).fadeIn("slow");	}
function ajaxhide(id){	$(id).fadeOut("slow");	}
function toggle(id)  {	$(id).slideToggle("fast");  }

// cufon replacements
Cufon.replace(' h1, h2, h3', { hover: true, fontFamily: 'Zurich' });
Cufon.replace(' .applyfont', { textShadow: '1px 1px #ffffff', hover: true, fontFamily: 'Zurich' });
Cufon.replace(' .bubble-one h2, .bubble-one h3, .bubble-one-alt h2, .bubble-one-alt h3', { textShadow: '1px 1px #5b5b5b', hover: true, fontFamily: 'Zurich' });
Cufon.replace(' .bubble-two h2, .bubble-two h3', { textShadow: '1px 1px #125ea1', hover: true, fontFamily: 'Zurich' });
Cufon.replace(' .footer-big h3', { textShadow: '1px 1px #424242', fontFamily: 'Zurich' });
// Cufon.replace(' .mainmenu', {  hover: true , fontFamily: 'Arials' });
Cufon.replace(' .btn-big-action, .btn-small-action, .btn-big-action-fixed, .form-button', { textShadow: '1px 1px #5d5d5d', hover: true , fontFamily: 'Arials' });
Cufon.replace(' .btn-big-neutral,.btn-small-neutral, .btn-big-neutral-fixed', { textShadow: '1px 1px #ffffff', hover: true , fontFamily: 'Arials' });
Cufon.replace(' ul.pricing-col li.tops h2, ul.pricing-col-highlight li.tops h2', { textShadow: '1px 1px #5d5d5d', hover: true, fontFamily: 'Zurich' });


// dd_roundies for damned IE, make rounded corners on some boxes
DD_roundies.addRule('.outer-rounded-box', '10px');
DD_roundies.addRule('.outer-rounded-box-bold', '12px');
DD_roundies.addRule('.inner-rounded-box-filled-grey', '10px');
DD_roundies.addRule('.inner-rounded-box-filled-white', '10px');
DD_roundies.addRule('.inner-rounded-box-gradient-up', '10px');
DD_roundies.addRule('.inner-rounded-box-gradient-down', '10px');
DD_roundies.addRule('.simple-rounded-box', '10px');
DD_roundies.addRule('form select', '5px');
DD_roundies.addRule('form input', '5px');
DD_roundies.addRule('form textarea', '5px');

// run dynamic bubbletips
$(window).bind('load', function() {
          var ix = 1;
          while($('#trigger' + ix + '_up').length > 0) {
          $('#trigger' + ix + '_up').bubbletip($('#tip' + ix + '_up'), {
          deltaDirection: 'up',
          deltaPosition: 50,
          offsetTop: 5,
          calculateOnShow: true
          });
          ix++;
}
});
