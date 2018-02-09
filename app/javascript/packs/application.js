import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

// Rails UJS
Rails.start();

// Turbolinks
Turbolinks.start();

// Stimulus
const application = Application.start();
const context = require.context('../controllers', true, /\.js$/);
application.load(definitionsFromContext(context));
