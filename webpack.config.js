var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var autoprefixer = require('autoprefixer');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var OfflinePlugin = require('offline-plugin');

console.log('WEBPACK GO!');

var TARGET_ENV;
// detemine build env
switch (process.env.npm_lifecycle_event) {
  case 'build':
    TARGET_ENV = 'production';
    break;
  default:
    TARGET_ENV = 'development';
}

var DIST_DIR = path.resolve(__dirname, 'dist/');

// common webpack config
var commonConfig = {

  output: {
    path: DIST_DIR,
    filename: '[hash].js',
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },

  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        loader: 'file-loader'
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/index.html',
      inject: 'body',
      filename: 'index.html'
    }),
    new webpack.DefinePlugin({
      ENV: { 'TARGET': TARGET_ENV }
    })
  ],

  postcss: [autoprefixer({
    browsers: ['last 2 versions']
  })],

}

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  console.log('Serving locally...');

  module.exports = merge(commonConfig, {

    entry: [
      'webpack-dev-server/client?http://localhost:8080',
      path.join(__dirname, 'src/index.js')
    ],

    devServer: {
      inline: true,
      progress: true
    },

    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
        },
        {
          test: /\.(css|scss)$/,
          loaders: [
            'style-loader',
            'css-loader',
            'postcss-loader',
            'sass-loader'
          ]
        }
      ]
    }

  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  console.log('Building for prod...');

  module.exports = merge(commonConfig, {

    entry: path.join(__dirname, 'src/index.js'),

    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-webpack'
        },
        {
          test: /\.(css|scss)$/,
          loader: ExtractTextPlugin.extract('style-loader', [
            'css-loader',
            'postcss-loader',
            'sass-loader'
          ])
        }
      ]
    },

    plugins: [
      new CopyWebpackPlugin([
        {
          from: 'src/img/',
          to: 'img/'
        },
        {
          from: 'src/favicon.ico'
        },
        {
          from: 'CNAME'
        },
        {
          from: 'src/passy.party.webmanifest'
        },
      ]),

      new webpack.optimize.OccurenceOrderPlugin(),

      // extract CSS into a separate file
      new ExtractTextPlugin('./[hash].css', {
        allChunks: true
      }),

      // minify & mangle JS/CSS
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: {
          warnings: false
        }
      // mangle:  true
      }),

      new OfflinePlugin(),
    ]
  });
}
