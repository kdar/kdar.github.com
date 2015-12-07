var $ = require('jquery');
// $.fn.dimmer = require("semantic-ui-dimmer");
$.fn.sidebar = require('semantic-ui-sidebar');
var photoswipe = require('photoswipe');

require('salvattore');

$(function() {
  // $('.dimmer').dimmer({
  //   on: 'hover',
  //   transition: 'slide'
  // });

  $('.ui.sidebar').sidebar('attach events', '.toc.item');

  var menu = document.querySelector('.menu-wrapper');
  var offset = menu.offsetTop;
  $(window).on('scroll', function() {
    if (window.scrollY > offset) {
      menu.classList.add('fixed');
    } else {
      menu.classList.remove('fixed');
    }
  });
});
