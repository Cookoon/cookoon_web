module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/, // Check for all js files
        exclude: /node_modules\/(?!(dom7|swiper)\/).*/,
        loader: 'babel-loader'
      }
    ]
  }
};
