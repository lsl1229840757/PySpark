echo start hadoop-hive container...
docker run -itd --restart=always --net spark --ip 172.16.0.5 --privileged --name hive --hostname hadoop-hive --add-host hadoop-node1:172.16.0.3 \
--add-host hadoop-node2:172.16.0.4 --add-host hadoop-mysql:172.16.0.6 --add-host hadoop-maste:172.16.0.2 spark /bin/bash
echo start hadoop-mysql container ...
docker run -itd --restart=always --net spark --ip 172.16.0.6 --privileged --name mysql --hostname hadoop-mysql --add-host hadoop-node1:172.16.0.3 --add-host hadoop-node2:172.16.0.4 --add-host hadoop-hive:172.16.0.5 --add-host hadoop-maste:172.16.0.2 spark /bin/bash
echo start hadoop-maste container ...
docker run -itd --restart=always \--net spark \--ip 172.16.0.2 \--privileged \-p 18032:8032 \-p 28080:18080 \-p 29888:19888 \-p 17077:7077 \-p 51070:50070 \-p 18888:8888 \-p 19000:9000 \-p 11100:11000 \-p 51030:50030 \-p 18050:8050 \-p 18081:8081 \-p 18900:8900 \--name hadoop-maste \
--hostname hadoop-maste  \--add-host hadoop-node1:172.16.0.3 \--add-host hadoop-node2:172.16.0.4 --add-host hadoop-hive:172.16.0.5 --add-host hadoop-mysql:172.16.0.6 spark /bin/bash
echo "start hadoop-node1 container..."
docker run -itd --restart=always \--net spark  \--ip 172.16.0.3 \--privileged \-p 18042:8042 \-p 51010:50010 \-p 51020:50020 \--name hadoop-node1 \--hostname hadoop-node1  --add-host hadoop-hive:172.16.0.5 --add-host hadoop-mysql:172.16.0.6 \--add-host hadoop-maste:172.16.0.2 \--add-host hadoop-node2:172.16.0.4 spark  /bin/bash
echo "start hadoop-node2 container..."
docker run -itd --restart=always \--net spark  \--ip 172.16.0.4 \--privileged \-p 18043:8042 \-p 51011:50011 \-p 51021:50021 \--name hadoop-node2 \--hostname hadoop-node2 --add-host hadoop-maste:172.16.0.2 \--add-host hadoop-node1:172.16.0.3 --add-host hadoop-mysql:172.16.0.6 --add-host hadoop-hive:172.16.0.5 spark /bin/bash
echo start sshd...
docker exec -it hadoop-maste /etc/init.d/ssh start
docker exec -it hadoop-node1 /etc/init.d/ssh start
docker exec -it hadoop-node2 /etc/init.d/ssh start
docker exec -it hive  /etc/init.d/ssh start
docker exec -it mysql /etc/init.d/ssh start
docker exec -it mysql sh ~/init_mysql.sh
docker exec -it hadoop-maste sh ~/start-hadoop.sh 
docker exec -it hive  sh ~/init_hive.sh
echo finished
docker ps
