#!/bin/bash
export NODE_PATH=/op-sharedbus/node_modules
export SWARM_NODE_TYPE='operando'
export SWARM_PATH=/op-sharedbus/
#http-server /op-sharedbus/operando/admin/ -p 8010&
nohup redis-server&
#redis-server
node /op-sharedbus/adapters/demoLaunch.js
