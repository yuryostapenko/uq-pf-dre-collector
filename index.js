const moment = require('moment');
const uuid = require('uuid');

const AWS = require('aws-sdk');
AWS.config.update({region: 'ap-southeast-2'});


const INTERVAL = 5000;

const s3 = new AWS.S3();
const bucketName = 'uq-its-ss-pf-dre';

let timer;

(cycle = () => {
  timer = setTimeout(() => {
    runTask();
    cycle();
  }, INTERVAL);
})();


const runTask = () => {
  const keyName = `${moment().format('YYYY-MM-DD-HH-mm-ss')}-omega-${uuid.v4()}.txt`;
  
  
  s3.createBucket({Bucket: bucketName}, (err, data) => {
    if (err.code !== 'BucketAlreadyOwnedByYou') {
      console.log(err);
    }

    const params = { Bucket: bucketName, Key: keyName, Body: 'Hello World!' };
    s3.putObject(params, (err, data) => {
      if (err)
        console.log(err);
      else
        console.log("Successfully uploaded data to " + bucketName + "/" + keyName);
    });    
  });  
};