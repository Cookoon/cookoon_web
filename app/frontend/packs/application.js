import Rails from 'vendor/rails-ujs';
import Turbolinks from 'turbolinks';
import application from 'stimulus_application';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

import 'bootstrap';
import 'cloudinary-jquery-file-upload';
// $(function() {
//   if ($.fn.cloudinary_fileupload !== undefined) {
//     $('input.cloudinary-fileupload[type=file]').cloudinary_fileupload();
//   }
// });

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
