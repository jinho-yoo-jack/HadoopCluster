FROM ubuntu:22.04

LABEL email="jhy7342@gmial.com"
LABEL name="jin"
LABEL version="1.0"
LABEL description="Hadoop 3.3.5"

RUN mkdir /data
RUN useradd -s /bin/bash -p 'bigdata' hadoop && \
    mkdir -p /home/hadoop && \
    chown -R hadoop:hadoop /home/hadoop && \
    mkdir -p /home/hadoop/install_file && \
    mkdir -p /home/hadoop/bin

# install openssh-server, openjdk and wget
RUN apt-get -y update && \
    apt-get install -y openssh-server openjdk-8-jdk wget vim net-tools

# SSH Config
RUN cd ~/ && \
    ssh-keygen -t rsa -P 'bigdata' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Make directory about Hadoop DFS
RUN mkdir -p ~/hdfs/namenode && \
    mkdir -p ~/hdfs/datanode

# install hadoop 3.3.5
#RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz && \
COPY install/* /home/hadoop/install_file
RUN cd /home/hadoop/install_file && \
    tar -xzvf hadoop-3.3.5.tar.gz && \
    mv hadoop-3.3.5 /home/hadoop/bin/hadoop && \
    rm hadoop-3.3.5.tar.gz && \
    tar -xzvf apache-zookeeper-3.8.0-bin.tar.gz && \
    tar -xzvf apache-zookeeper-3.8.0-bin.tar.gz && \
    mv apache-zookeeper-3.8.0-bin /home/hadoop/bin/zookeeper && \
    rm apache-zookeeper-3.8.0-bin.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
ENV HADOOP_HOME=/home/hadoop/bin/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV ZOOKEEPER_HOME=/home/hadoop/bin/zookeeper
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZOOKEEPER_HOME/bin

# COPY SSH Config
COPY config/sshd/sshd_config /etc/sshd/

# Change File Owner
RUN chown -R hadoop:hadoop /home/hadoop

# format namenode
#RUN /usr/local/hadoop/bin/hdfs namenode -format