#!/bin/bash
PID=$(lsof -t -i:25565)
if [ -z "$PID" ]; then
   echo "No service running on port 25565"
else
   kill -9 $PID
   echo "Service running on port 25565 has been terminated"
fi