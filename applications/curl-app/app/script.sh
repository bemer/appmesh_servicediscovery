#!/bin/sh
while true
do
    curl -s http://$APP_HOST:$APP_PORT 
    echo
    sleep 1
done
