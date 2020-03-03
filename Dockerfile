FROM ubuntu:18.04

MAINTAINER maple "ww1516123@126.com"
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean

#1,install jdk
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

#install wget
RUN apt-get update && \
        apt-get -y install wget

#2,install ZK
RUN cd /opt && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz  && \
    tar -zxvf zookeeper-3.4.14.tar.gz  && \
    mv zookeeper-3.4.14 zookeeper && \
    rm -rf ./zookeeper-*tar.gz && \
    mkdir -p /tmp/zookeeper && \
    rm -rf /opt/zookeeper/conf/zoo_sample.cfg
	
#3,install maven
RUN cd /opt && \
    wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -zxvf apache-maven-3.3.9-bin.tar.gz && \
    mv apache-maven-3.3.9 maven && \
    rm -rf ./apache-maven-*tar.gz && \
    rm -rf /opt/maven/conf/settings.xml

#4,install postgresql
RUN apt-get update && \
	    apt-get install -y postgresql postgresql-contrib sudo && \
	    sed -i 's/localhost/*/g' /etc/postgresql/10/main/postgresql.conf

#5,install sudo,python,vim,ping and ssh command
RUN apt-get update && \
  apt-get -y install sudo && \
  apt-get -y install python && \
  apt-get -y install vim && \
  apt-get -y install iputils-ping && \
  apt-get -y install net-tools && \
  apt-get -y install openssh-server && \
  apt-get -y install python-pip  && \
  pip install kazoo
  
RUN cd /opt && \
      wget https://nodejs.org/download/release/v8.9.4/node-v8.9.4-linux-x64.tar.gz && \
      tar -zxvf node-v8.9.4-linux-x64.tar.gz && \
      mv node-v8.9.4-linux-x64 node && \
      rm -rf ./node-v8.9.4-*tar.gz
		
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/* && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx
  
# set env
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ZK_HOME=/opt/zookeeper
ENV MAVEN_HOME=/opt/maven
ENV NODE_HOME=/opt/node
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin:$ZK_HOME/bin:$NODE_HOME/bin
