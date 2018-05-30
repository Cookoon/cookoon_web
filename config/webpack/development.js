process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const environment = require('./environment');
const webpackBundleAnalyzerConfig = require('./config/webpackBundleAnalyzer');

environment.config.merge(webpackBundleAnalyzerConfig);

module.exports = environment.toWebpackConfig();
