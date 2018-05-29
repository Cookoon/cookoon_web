import application from 'stimulus_application';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import './drawer.scss';

const context = require.context('./', true, /_controller\.js$/);
application.load(definitionsFromContext(context));

// TODO: FC 25may18 move to turbolinks_controller.js?
const hideNavigation = function() {
  // nav.removeClass('ssm-nav-visible');
  // scrollNav(navWidth, settings.speed);
  // $('html').removeClass('is-navOpen');
  // $('.ssm-overlay').fadeOut();

  $('.side-nav').css('transform', 'translate(-280px, 0px)');
  $('.ssm-overlay').hide();
  $('html').removeClass('is-navOpen');
  $('.side-nav').removeClass('ssm-nav-visible');
};

document.addEventListener('turbolinks:before-cache', function() {
  hideNavigation();
});
