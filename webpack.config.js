var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var StyleLintPlugin = require('stylelint-webpack-plugin');
var sugarss = require('sugarss');
var autoprefixer = require('autoprefixer');
var postcssNesting = require('postcss-nesting');
// сортировка css-стилей по выбраному шаблону
// https://github.com/hudochenkov/postcss-sorting

module.exports = {
  entry: ["./web/static/css/app.sss", "./web/static/js/app.js"],

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
        test: /\.sss$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!postcss-loader?parser=sugarss')
      }
    ]
  },

// добавить css modules
// добавить спрайт(?)
  postcss() {
    return {
      plugins: [autoprefixer, postcssNesting]
    };
  },

  plugins: [
    new StyleLintPlugin({
      configFile: '.stylelintrc',
      context: 'web/static/css',
      files: '**/*.sss',
      failOnError: false,
      quiet: false,
    }),
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./web/static/assets" }])
  ]
};
