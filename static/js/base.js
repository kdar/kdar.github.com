// $(function() {
//   $(window).on('scroll', function() {
//     var st = $(this).scrollTop();
//     $("
//     // sliderBackground.css({ 'opacity' : (0.5 - st/800) });
//     // sliderImages.css({ 'opacity' : (1 - st/400) });
//     // sliderText.css({ 'opacity' : (1 - st/100) });
//     // sliderButtons.css({ 'opacity' : (1 - st/300) });
//   	// sliderLogo.css({ 'opacity' : (1 - st/550) });
//   });
// });


document.addEventListener("DOMContentLoaded", function(event) {
  //var header = document.querySelector('.site-layout .mdl-layout__header');
  var nav = document.querySelector('.site-nav');
  var navoffset = nav.offsetTop;
  window.addEventListener("scroll", function() {
    if (window.scrollY >= navoffset) {
      nav.classList.add('nav-fixed');
    } else {
      nav.classList.remove('nav-fixed');
    }
  });

  // document.onscroll = function() {
  //   console.log(nav.offsetTop);
  //   // var menu = document.querySelector('.po-nav');
  //   // 		var origOffsetY = menu.offsetTop;
  //   //
  //   // 		function scroll () {
  //   // 		  if ($(window).scrollTop() >= origOffsetY) {
  //   // 			$('.po-navbar-slide').addClass('navbar-fixed-top');
  //   // 			$('.po-nav-slide').addClass('nav-fixed-padding');
  //   // 		  } else {
  //   // 			$('.po-navbar-slide').removeClass('navbar-fixed-top');
  //   // 			$('.po-nav-slide').removeClass('nav-fixed-padding');
  //   // 		  }
  //   //
  //   //
  //   // 		}
  // };
});
