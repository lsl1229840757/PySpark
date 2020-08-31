# From的镜像已上传至DockerHub
FROM lsl1229840757/lslubuntu:18.04
MAINTAINER lsl 1229840757@qq.com

# 设置build时间环境变量
ENV BUILD_ON 2020-08-26

# 把config目录下面的所有文件拷贝到镜像的/tmp中
COPY config /tmp

# 如果不能上网的话, 这里可以配置上网代理
# RUN mv /tmp/apt.conf /etc/apt/

# 在根目录之下创建.pip文件夹, 用来保存中国源
RUN mkdir -p ~/.pip/
RUN mv /tmp/pip.conf ~/.pip/pip.conf

# 执行apt-get的更新
RUN apt-get update -qqy

# apt安装需要交互就用这个
ENV DEBIAN_FRONTEND noninteractive

# 安装常用的软件
RUN apt-get -qqy install netcat-traditional vim wget net-tools iputils-ping openssh-server python3-pip libaio-dev apt-utils

# 安装Python常用包
RUN pip3 install pandas numpy matplotlib sklearn seaborn scipy tensorflow gensim

# 添加Python的软连接
RUN ln -s /usr/bin/python3.6 /usr/bin/python

# 添加JDK
ADD ./jdk-8u101-linux-x64.tar.gz /usr/local 
# 添加hadoop
ADD ./hadoop-2.7.3.tar.gz /usr/local
# 添加scala
ADD ./scala-2.11.8.tgz /usr/local
# 添加spark
ADD ./spark-2.3.0-bin-hadoop2.7.tgz /usr/local
# 添加mysql
ADD ./mysql-5.5.45-linux2.6-x86_64.tar.gz /usr/local
RUN mv /usr/local/mysql-5.5.45-linux2.6-x86_64 /usr/local/mysql
ENV MYSQL_HOME /usr/local/mysql
# 添加hive
ADD ./apache-hive-2.3.2-bin.tar.gz /usr/local
ENV HIVE_HOME /usr/local/apache-hive-2.3.2-bin
RUN echo "HADOOP_HOME=/usr/local/hadoop-2.7.3" | cat >> /usr/local/apache-hive-2.3.2-bin/conf/hive-env.sh
# 添加mysql的java驱动到hive的lib中
ADD ./mysql-connector-java-5.1.37-bin.jar /usr/local/apache-hive-2.3.2-bin/lib
# 把mysql的驱动拷贝到spark的jars中
RUN cp /usr/local/apache-hive-2.3.2-bin/lib/mysql-connector-java-5.1.37-bin.jar /usr/local/spark-2.3.0-bin-hadoop2.7/jars

# 增加JAVA环境变量
ENV JAVA_HOME /usr/local/jdk1.8.0_101
# 增加Hadoop环境变量
ENV HADOOP_HOME /usr/local/hadoop-2.7.3
# 增加scala环境变量
ENV SCALA_HOME /usr/local/scala-2.11.8
# 增加spark环境变量
ENV SPARK_HOME /usr/local/spark-2.3.0-bin-hadoop2.7
# 将环境变量添加到系统变量中
ENV PATH $HIVE_HOME/bin:$MYSQL_HOME/bin:$SCALA_HOME/bin:$SPARK_HOME/bin:$HADOOP_HOME/bin:$JAVA_HOME/bin:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$PATH

# 配置SSH免登陆
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

# 将配置移动到正确位置
COPY config /tmp
RUN mv /tmp/ssh_config    ~/.ssh/config && \
    mv /tmp/profile /etc/profile && \
    mv /tmp/masters $SPARK_HOME/conf/masters && \
    cp /tmp/slaves $SPARK_HOME/conf/ && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    cp /tmp/hive-site.xml $SPARK_HOME/conf/hive-site.xml && \
    mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/master $HADOOP_HOME/etc/hadoop/master && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mkdir -p /usr/local/hadoop2.7/dfs/data && \
    mkdir -p /usr/local/hadoop2.7/dfs/name && \
    mv /tmp/init_mysql.sh ~/init_mysql.sh && chmod 700 ~/init_mysql.sh && \
    mv /tmp/init_hive.sh ~/init_hive.sh && chmod 700 ~/init_hive.sh && \
    mv /tmp/restart-hadoop.sh ~/restart-hadoop.sh && chmod 700 ~/restart-hadoop.sh

# 检测JAVA_HOME
RUN echo $JAVA_HOME
# 设置工作目录
WORKDIR /root
# 启动sshd服务
RUN /etc/init.d/ssh start
# 修改start-hadoop.sh权限为700
RUN chmod 700 start-hadoop.sh
# 修改root密码
RUN echo "root:12345" | chpasswd
# 容器运行时启动bash
CMD ["/bin/bash"]
