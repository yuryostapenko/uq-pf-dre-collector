const moment = require('moment');
const _ = require('lodash');

const AWS = require('aws-sdk');
AWS.config.update({ region: 'ap-southeast-2' });

const INTERVAL = 5000;
const meters = [
  'alpha',
  'beta',
  'gamma',
  'delta',
  'epsilon',
  'zeta',
  'eta',
  'theta',
  'iota',
  'kappa',
  'lambda',
  'mu',
  'nu',
  'xi',
  'omicron',
  'pi',
  'rho',
  'sigma',
  'tau',
  'upsilon',
  'phi',
  'chi',
  'psi',
  'omega',
];

const s3 = new AWS.S3();
const bucketName = 'pf-dre-collector';

let timer;

(cycle = () => {
  timer = setTimeout(() => {
    runTask();
    cycle();
  }, INTERVAL);
})();


const runTask = () => {
  const dateId = moment().format('YYYY-MM-DD-HH-mm-ss');
  const meter = _.sample(meters);
  const keyName = `new/${meter}/${dateId}-${meter}.json`;


  s3.createBucket({ Bucket: bucketName }, (err, data) => {
    if (err.code !== 'BucketAlreadyOwnedByYou') {
      console.log(err);
    }

    const params = {
      Bucket: bucketName,
      Key: keyName,
      Body: `{ "id": "${dateId}", "meterCode": "${meter}", "value": "${_.random(-100, 100)}" }`
    };
    s3.putObject(params, (err, data) => {
      if (err)
        console.log(err);
      else
        console.log("Successfully uploaded data to " + bucketName + "/" + keyName);
    });
  });
};
