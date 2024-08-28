#!/usr/bin/env bash

set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "CURRENT_DIR : $CURRENT_DIR"

RUN_DIRECTORY="$(dirname "$CURRENT_DIR")"
#echo "RUN_DIRECTORY : $RUN_DIRECTORY"

SRC_DIRECTORY="$(dirname "$RUN_DIRECTORY")"
#echo "SRC_DIRECTORY : $SRC_DIRECTORY"

ROOT_DIRECTORY="$(dirname "$SRC_DIRECTORY")"
echo "ROOT_DIRECTORY : $ROOT_DIRECTORY"

#copy compiled jar file to master container
# docker cp $ROOT_DIRECTORY/mapper.py  master:/tmp/mapper.py
# docker cp $ROOT_DIRECTORY/reducer.py  master:/tmp/reducer.py
# docker cp $CURRENT_DIR/sancar.txt  master:/tmp/sancar.txt
docker cp $CURRENT_DIR/hadoop.sh  master:/tmp/hadoop.sh


docker exec -it master bash -c  "/tmp/hadoop.sh"

