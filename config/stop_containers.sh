docker stop hadoop-maste
docker stop hadoop-node1
docker stop hadoop-node2
docker stop hive
docker stop mysql
echo stop containers 
docker rm hadoop-maste
docker rm hadoop-node1
docker rm hadoop-node2
docker rm hive
docker rm mysql

echo rm containers

docker ps
