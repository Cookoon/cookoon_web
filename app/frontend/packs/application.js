import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import application from 'stimulus_application';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

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

// TODO: remove when removing Sprockets
window.$ = window.jQuery = require('jquery');
