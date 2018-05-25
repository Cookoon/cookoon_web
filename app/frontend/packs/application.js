import Rails from 'vendor/rails-ujs';
import Turbolinks from 'turbolinks';
import application from 'stimulus_application';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import 'components';

// Rails UJS
Rails.start();

// Turbolinks
Turbolinks.start();

// Stimulus
const context = require.context('../controllers', true, /\.js$/);
application.load(definitionsFromContext(context));
