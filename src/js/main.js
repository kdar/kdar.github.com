var $ = require('jquery');
global.jQuery = $;
$.fn.sidebar = require('semantic-ui-sidebar');
var photo = require('./photo');
var rrssb = require('rrssb');

require('salvattore');

$(function() {
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

  photo();
});
