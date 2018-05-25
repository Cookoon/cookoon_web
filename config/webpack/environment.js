const { environment } = require('@rails/webpacker');

const swiperConfig = require('./config/swiper');

environment.config.merge(swiperConfig);

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
);

module.exports = environment;
