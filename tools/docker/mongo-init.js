#!/usr/bin/mongo --quiet
const mongoUrl = process.env.MONGO_URL;
db = connect(mongoUrl);

load('/docker-entrypoint-initdb.d/assets/cottages.js');
//
db.cottages.insertMany(myData);
