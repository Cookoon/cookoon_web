const { environment } = require('@rails/webpacker');
const swiperConfig = require('./config/swiper');

environment.config.merge(swiperConfig);

module.exports = environment;
