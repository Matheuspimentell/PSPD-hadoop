#!/bin/bash

# Get the location of the current directory
localdir=$(pwd)

#set default slave container count if its unset
if [ -z "$1" ]
  then
    slaveCount=1
  else
  	slaveCount=$1
fi

set -e

echo "$slaveCount slave and 1 master  container will be created..."

#add all slave containers name  to slaves file
for (( i=1; i<=$slaveCount; i++ ))
do
    echo "Exporting slave$i to salves file..."
    if [ $i -eq 1 ]
    then
        echo "slave$i" > ./conf/workers
    else
        echo "slave$i" >> ./conf/workers
    fi
done

#Create a network named "hadoopNetwork"
if [ ! "$(docker network list | grep hadoopNetwork)" ]; then
	echo "Creating hadoop network..."
	docker network create -d bridge --subnet 172.25.0.0/16 hadoopNetwork
else
	echo "hadoop network already exists."
fi

#Create base hadoop image named "base-hadoop:1.0"
docker build -t base-hadoop:1.0 .

#run base-hadoop:1.0 image as master container
docker run -itd --network="hadoopNetwork"  --ip 172.25.0.100  -p 9870:9870  -p 8088:8088 --rm --name master --hostname master -v "${localdir}/run_volume/:/tmp/run_volume/" base-hadoop:1.0


for (( c=1; c<=$slaveCount; c++ ))
do
	echo "starting slave $c..."	
  tmpName="slave$c"
  #run base-hadoop:1.0 image  as slave container
  docker run --rm -itd --network="hadoopNetwork" --ip "172.25.0.10$c" --name $tmpName --hostname $tmpName base-hadoop:1.0
done

# Copy word generator to master nod
docker cp ${localdir}/generator.py master:/generator.py

#run hadoop commands
docker exec -it master bash -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"
docker exec -it master bash

# 172.25.0.101    slave1
# 172.25.0.102    slave2
# 172.25.0.103    slave3