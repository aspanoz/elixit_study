var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var StyleLintPlugin = require('stylelint-webpack-plugin');
// сортировка css-стилей по выбраному шаблону
// https://github.com/hudochenkov/postcss-sorting

module.exports = {
  entry: ["./web/static/css/app.css", "./web/static/js/app.js"],

  output: {
    path: "./priv/static",
    filename: "js/app.js"
  },
  devtool: 'cheap-module-eval-source-map',
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        include: __dirname,
        loader: "babel",
        query: {
          presets: ["es2015"]
        }
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!postcss-loader')
      }
    ]
  },

  postcss: [ autoprefixer({ browsers: ['last 2 versions'] }) ],
  // postcss() {
  //   return {
  //     plugins: [sugarss, autoprefixer]
  //   };
  // },

  plugins: [
    new StyleLintPlugin({
      configFile: '.stylelintrc',
      context: 'web/static/css',
      files: '**/*.css',
      failOnError: false,
      quiet: false,
    }),
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./web/static/assets" }])
  ]
};
