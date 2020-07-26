#!/bin/bash

## Composer project name instead of git main folder name
#export COMPOSE_PROJECT_NAME=mongodbdocker

## Generate global auth key between cluster nodes
openssl rand -base64 756 > mongodb.key
chmod 600 mongodb.key

## Start the whole stack
docker-compose up -d 

## Config servers setup
docker exec -it mongo-configserver-01 sh -c "mongo --port 27017 < /mongo-configserver.init.js"

## Shard servers setup
docker exec -it mongo-shard-01a sh -c "mongo --port 27018 < /mongo-shard-01.init.js" 
docker exec -it mongo-shard-02a sh -c "mongo --port 27019 < /mongo-shard-02.init.js"
docker exec -it mongo-shard-03a sh -c "mongo --port 27020 < /mongo-shard-03.init.js"

## Apply sharding configuration
sleep 15
docker exec -it mongo-router-01 sh -c "mongo --port 27017 < /mongo-sharding.init.js"

## Enable admin account
docker exec -it mongo-router-01 sh -c "mongo --port 27017 < /mongo-auth.init.js"
