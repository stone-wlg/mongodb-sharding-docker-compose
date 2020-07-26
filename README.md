# mongodb-sharding-docker-compose

:whale: docker-compose stack that allows you to turn on a full MongoDB sharded cluster with the following components :

 * configserver replicaset: 3x mongod with configsrv enabled 
 * first replicaset shard: 3x mongod 
 * second replicaset shard: 3x mongod
 * third replicaset shard: 3x mongod
 * mongo query router: 1x mongos
 * authentication enabled + global auth key certificate between nodes

:warning: Of course this is for development purpose only  

    # Usage :
    $ git clone git@github.com:jfollenfant/mongodb-sharding-docker-compose.git
    $ mongodb-sharding-docker-compose
    $ ./up.sh
    
    
You can also edit mongo-auth.init.js to change admin credentials before turning up the cluster

    admin = db.getSiblingDB("admin")
    admin.createUser(
      {
         user: "admin",
         pwd: "admin",
         roles: [ { role: "root", db: "admin" } ] 
      }
    )

:tropical_drink: Then you should be able to log into the cluster:

    $ docker exec -it mongo-router-01 mongo admin  -u'admin' -p'admin'
    mongos> sh.status()
    
```mongo
mongos> use test
mongos> sh.enableSharding("test")
mongos> sh.shardCollection("test.users", { "name": "hashed" })
mongos> db.users.insertMany([{name:"1", age: 31, status: true},{name:"2", age: 32, status: false},{name:"3", age: 33, status: false}])
mongos> db.users.find()
mongos> db.users.getShardDistribution()

mongos> use config
mongos> db.databases.find()
```


:beer: And turn it down with:

    $ ./down.sh
    
    
# TODO :construction:
   
- Generate random data to populate shards through balancing 
  