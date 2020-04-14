import { Swiper, Navigation, Pagination, Autoplay } from 'swiper/dist/js/swiper.esm.js';
// import { Swiper, Navigation, Pagination } from 'swiper/dist/js/swiper.esm.js';
import 'swiper/dist/css/swiper.css';

import './swiper.scss';

Swiper.use([Navigation, Pagination, Autoplay]);
// Swiper.use([Navigation, Pagination]);

export default Swiper;
