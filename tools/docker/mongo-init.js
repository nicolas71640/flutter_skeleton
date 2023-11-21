#!/usr/bin/mongo --quiet

db = connect( 'mongodb://localhost/myapp' );

load('/docker-entrypoint-initdb.d/assets/cottages.js');

db.cottages.insertMany(myData);
