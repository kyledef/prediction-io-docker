#!/bin/bash

TRY=1 
while [ $TRY -ne 0 ]; do
	mongo $MONGO_IP:$MONGO_PORT/predictionio --eval "db.users.insert({_id : NumberInt(1), email : 'test@test.com', password : '`echo -n password|md5sum | cut -f1 -d' '`', firstname : '<user>', lastname : '<user>' })";
	let TRY=$?
	echo $TRY
done


