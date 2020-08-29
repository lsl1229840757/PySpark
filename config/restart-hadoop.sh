#!/bin/bash
echo -e "\n"

echo -e "\n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\n"

$SPARK_HOME/sbin/start-all.sh

echo -e "\n"

hdfs dfs -mkdir /mr-history

hdfs dfs -mkdir /stage


echo -e "\n"

