#!/bin/bash
cd /usr/local/apache-hive-2.3.2-bin/bin
sleep 3
nohup ./schematool -initSchema -dbType mysql &
sleep 3
nohup ./hive --service metastore  &
sleep 3
nohup ./hive --service hiveserver2 &
sleep 5
echo Hive has initiallized!
