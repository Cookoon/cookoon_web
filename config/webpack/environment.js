const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');

const swiperConfig = require('./config/swiper');

environment.config.merge(swiperConfig);

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
);

environment.plugins.prepend(
  'MomentIgnoreLocales',
  new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
);

environment.loaders.delete('nodeModules');

module.exports = environment;
