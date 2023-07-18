docker run -it -d --privileged --name hadoop-master-1 --network hadoop-network --add-host=hadoop-master-1:172.72.0.2 -p 38080:38080 -p 8088:8088 -p 50071:50071 -p 50075:50075 -p 19888:19888 hadoop-cluster:latest /sbin/init
docker run -it -d --privileged --name hadoop-master-2 --network hadoop-network --add-host=hadoop-master-2:172.72.0.3 -p 50072:50071 -p 50275:50075 -p 29888:19888 hadoop-cluster:latest /sbin/init

docker run -it -d --name hadoop-data-3 --network hadoop-network --add-host=hadoop-data-3:172.72.0.4 hadoop-cluster:latest
docker run -it -d --name hadoop-data-1 --network hadoop-network --add-host=hadoop-data-1:172.72.0.5 hadoop-cluster:latest
docker run -it -d --name hadoop-data-2 --network hadoop-network --add-host=hadoop-data-2:172.72.0.6 hadoop-cluster:latest
