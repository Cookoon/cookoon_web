import Rails from 'vendor/rails-ujs';
import Turbolinks from 'turbolinks';
import application from 'stimulus_application';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

// TODO: remove when removing jQuery
window.$ = window.jQuery = require('jquery');

import 'bootstrap';

import 'components';
import 'style';

// Rails UJS
Rails.start();

// Turbolinks
Turbolinks.start();

// Stimulus
const context = require.context('../controllers', true, /\.js$/);
application.load(definitionsFromContext(context));
