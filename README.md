vagrant-danfe
================================

spin up a cluster of 4 vms with Hadoop v2.4.1 and Spark v1.0.1. 

1. master-node : HDFS NameNode + Spark Master
2. yarn-node   : YARN ResourceManager + JobHistoryServer + ProxyServer
3. slave-node1 : HDFS DataNode + YARN NodeManager + Spark Slave
4. slave-node2 : HDFS DataNode + YARN NodeManager + Spark Slave

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant 1.4.3+](http://www.vagrantup.com/downloads.html).

3. Run 

```

    vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box
    // Git clone this project, and change directory (cd) into this project (directory).
    vagrant up // to create the VM (may take hell lot of time)
    vagrant status // and then 
    vagrant ssh master-node //to get into your VM. 

    vagrant destroy // only if you want to destroy and get rid of the VM :)

```

Some gotcha's.

1. Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters.
2. Make sure you have 4Gb of free memory for the VM. You may change the Vagrantfile to specify smaller memory requirements.
3. This project has NOT been tested with the VMWare provider for Vagrant.
4. You may change the script (common.sh) to point to a different location for Hadoop and Spark to be downloaded from. Here is a list of mirrors for Hadoop: http://www.apache.org/dyn/closer.cgi/hadoop/common/.


# Post-Provisioning

- run some commands to initialize your Hadoop cluster as root. 

- su @ vagrant

## Start Hadoop Daemons (HDFS)

SSH into master-node and issue the following commands to start HDFS.

```
// SSH into master-node and issue the following command.

$HADOOP_PREFIX/bin/hdfs namenode -format myhadoop
$HADOOP_PREFIX/sbin/hadoop-daemon.sh  --config $HADOOP_CONF_DIR --script hdfs start namenode
$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
```


### Start Hadoop Daemons (YARN)

```
// SSH into yarn-node and issue the following commands to start YARN.

$HADOOP_YARN_HOME/sbin/yarn-daemon.sh  --config $HADOOP_CONF_DIR start resourcemanager
$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager

$HADOOP_YARN_HOME/sbin/yarn-daemon.sh       start proxyserver --config $HADOOP_CONF_DIR
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR

### Test YARN
### Run the following command to make sure you can run a MapReduce job.

yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.4.1.jar pi 2 100

```

## Start Spark in Standalone Mode
SSH into master-node and issue the following command.

```
$SPARK_HOME/sbin/start-all.sh

### Test Spark on YARN
### test if Spark can run on YARN by issuing the following command. Try NOT to run this command on the slave nodes.

$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn \
    --num-executors 10 \
    --executor-cores 2 \
    $SPARK_HOME/lib/spark-examples*.jar \
    100


### Test code directly on Spark	

$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master spark://master-node:7077 \
    --num-executors 10 \
    --executor-cores 2 \
    $SPARK_HOME/lib/spark-examples*.jar \
    100

	
### Test Spark using Shell
### Start the Spark shell using the following command. Try NOT to run this command on the slave nodes.

$SPARK_HOME/bin/spark-shell --master spark://master-node:7077

Then go here https://spark.apache.org/docs/latest/quick-start.html to start the tutorial. 
Most likely, you will have to load data into HDFS to make the tutorial work (Spark cannot read data on the local file system).

```

# Web UI
can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://10.211.55.101:50070/dfshealth.html)
2. [ResourceManager] (http://10.211.55.102:8088/cluster)
3. [JobHistory] (http://10.211.55.102:19888/jobhistory)
4. [Spark] (http://10.211.55.101:8080)


Reference
----------

https://github.com/vangj/vagrant-hadoop-2.4.1-spark-1.0.1

