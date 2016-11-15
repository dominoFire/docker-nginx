#! /bin/bash

set -e 

source container/vars.sh

docker build . -t ${IMAGE_NAME}
