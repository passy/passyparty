'use strict';

const path = require('path');

const DIST_DIR = path.join(__dirname, 'dist');

require('gh-pages').publish(DIST_DIR, function (err) {
  if (err) {
    console.err(err);
  }
});
