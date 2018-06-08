#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


# Environment
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

NOTEBOOKFOLDER="$SCRIPTPATH/notebook"

NOTEBOOKCONTAINER="jupyternotebook"
DBCONTAINER="postgresdb"
NETWORK="jupyterpostgres"

NOTEBOOKPORT=12345
DBPORT=12346

DBPASSWORD="root"

NOTEBOOKPACKAGE="stockmind/docker-jupyter-sql-notebook"
DBPACKAGE="postgres:9.6.9"

# If network doesn't exists, create it
if [ ! "$(docker network ls -f name=$NETWORK -q)" ]; then
	echo "Create network $NETWORK..."
	docker network create $NETWORK
fi

if [[ "$(docker ps -aq -f status=exited -f name=$NOTEBOOKCONTAINER)" || "$(docker ps -q -f name=$NOTEBOOKCONTAINER)" ]]; then
    # container exists, launch them
	echo "Starting containers..."
	docker start "$NOTEBOOKCONTAINER"
	docker start "$DBCONTAINER"
else
	# container never launched, run containers for first time
	# Update to latest container version
	docker pull "$NOTEBOOKPACKAGE"
	
	echo "Create containers..."
	docker run --name "$DBCONTAINER" -d -e MYSQL_DATABASE="$DBCONTAINER" -e MYSQL_ROOT_PASSWORD="$DBPASSWORD" -p "$DBPORT":3306 --network "$NETWORK" "$DBPACKAGE"
	docker run --name "$NOTEBOOKCONTAINER" -d -v "$NOTEBOOKFOLDER":/home/jovyan/work -p "$NOTEBOOKPORT":8888 --network "$NETWORK" "$NOTEBOOKPACKAGE"
fi	

TOKEN=$(docker exec -i "$NOTEBOOKCONTAINER" /opt/conda/bin/jupyter notebook list | grep token | sed 's|.*token=\(.*\)::.*|\1|')

echo -e "Database on port ${GREEN}$DBPORT${NC}.\n${BLUE}http://127.0.0.1:$DBPORT${NC}"
echo -e "Web on port ${GREEN}$NOTEBOOKPORT${NC}.\n${BLUE}http://127.0.0.1:$NOTEBOOKPORT?token=$TOKEN${NC}"
