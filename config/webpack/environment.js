const { environment } = require('@rails/webpacker');
const swiperConfig = require('./swiper_config');

environment.config.merge(swiperConfig);

module.exports = environment;
