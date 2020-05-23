#!/usr/bin/env bash
cd "$(dirname "$0")"
BRANCH_NAME=$(git symbolic-ref HEAD | sed -e "s/^refs\/heads\///")
OUTPUT_DIR=release/linux/amd64/
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

echo "BUILDING AGENT"
go build -tags "nolimit" -o ${OUTPUT_DIR} github.com/drone/drone/cmd/drone-agent

echo "BUILDING CONTROLLER"
go build -tags "nolimit" -o ${OUTPUT_DIR} github.com/drone/drone/cmd/drone-controller

echo "BUILDING SERVER"
go build -tags "nolimit" -o ${OUTPUT_DIR} github.com/drone/drone/cmd/drone-server

echo "BUILDING DOCKER AGENT"
docker build --rm -f docker/Dockerfile.agent.linux.amd64 -t dr.lulz.ovh/drone/drone-agent .
docker tag dr.lulz.ovh/drone/drone-agent dr.lulz.ovh/drone/drone-agent:${BRANCH_NAME}
docker push dr.lulz.ovh/drone/drone-agent
docker push dr.lulz.ovh/drone/drone-agent:${BRANCH_NAME}

echo "BUILDING DOCKER CONTROLLER"
docker build --rm -f docker/Dockerfile.controller.linux.amd64 -t dr.lulz.ovh/drone/drone-controller .
docker tag dr.lulz.ovh/drone/drone-controller dr.lulz.ovh/drone/drone-controller:${BRANCH_NAME}
docker push dr.lulz.ovh/drone/drone-controller
docker push dr.lulz.ovh/drone/drone-controller:${BRANCH_NAME}

echo "BUILDING DOCKER SERVER"
docker build --rm -f docker/Dockerfile.server.linux.amd64 -t dr.lulz.ovh/drone/drone-server .
docker tag dr.lulz.ovh/drone/drone-server dr.lulz.ovh/drone/drone-server:${BRANCH_NAME}
docker push dr.lulz.ovh/drone/drone-server
docker push dr.lulz.ovh/drone/drone-server:${BRANCH_NAME}
