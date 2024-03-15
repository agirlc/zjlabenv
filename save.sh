#/bin/bash
USR=$1

if [ -z "$USR" ]; then
	echo "User name invalid!"
	echo "Usage:"
	echo "bash save.sh <your user name>"
	exit 1
fi

# check container num 
num=`docker ps | grep $USR | wc -l`
if [ "$num" -gt 1 ]; then
	echo "There are more than one containers, i dont konw which one to save!"
    docker ps | grep $USR
    exit 4
fi

container=`docker ps | grep $USR | head -n1 | awk '{print $1}'`

if [ -z "$container" ]; then
	echo "user $USR" not have docker container running
	echo "please check with 'docker ps'"
	exit 2
fi

echo "Commit changes to $USR-python:latest..."

docker commit $container $USR-python:latest

image=`docker images | grep $USR-python | head -n1 | awk '{print $3}'`

if [ -z "$image" ]; then
	echo "image save ERROR"
	echo "please check with 'docker images'"
	exit 3
fi

if [ -f $USR-python.tar ]; then
	echo "Backup $USR-python.tar to $USR-bak.tar"
	mv $USR-python.tar $USR-bak.tar
fi

echo "Save image $image to file $USR-python.tar"
docker save -o $USR-python.tar $image
