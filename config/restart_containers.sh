echo stop containers
docker stop hadoop-maste
docker stop hadoop-node1
docker stop hadoop-node2
docker stop hive
docker stop mysql
echo restart containers
docker start hadoop-maste
docker start hadoop-node1
docker start hadoop-node2
docker start hive
docker start mysql
echo start sshd
docker exec -it hadoop-maste /etc/init.d/ssh start
docker exec -it hadoop-node1 /etc/init.d/ssh start
docker exec -it hadoop-node2 /etc/init.d/ssh start
docker exec -it hive /etc/init.d/ssh start
docker exec -it mysql /etc/init.d/ssh start
echo start mysql 、hadoop、spark、hive
docker exec -it mysql sh ~/init_mysql.sh
docker exec -it hadoop-maste ~/restart-hadoop.sh
docker exec -it hive sh ~/init_hive.sh
echo  containers started

docker ps
