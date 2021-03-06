'use strict';

require('./styles/main.scss');

if (ENV.TARGET_ENV === 'production') {
  require('offline-plugin/runtime').install();
}

const Elm = require('./Main');
const moment = require('moment');
const app = Elm.Main.embed(document.getElementById('main'));

app.ports.requestDuration.subscribe(function (ms) {
  const dur = moment.duration(ms);
  app.ports.duration.send({
    days: Math.floor(dur.asDays()),
    hours: dur.hours(),
    minutes: dur.minutes(),
    seconds: dur.seconds()
  });
});
