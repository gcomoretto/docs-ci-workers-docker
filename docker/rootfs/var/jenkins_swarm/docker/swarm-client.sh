#!/bin/bash

# this client is running docker:
/usr/bin/dockerd --host=tcp://localhost:2375 --mtu=1376 2>&1 > ${SWARM_HOME}/docker.log &

# configuring and running the Jenkins Swarm Worker
if [ -z $JENKINS_MASTER_URL ]; then
    JENKINS_MASTER_URL=https://lsst-docs-ci.ncsa.illinois.edu/jenkins/
fi

if [ -z $JENKINS_SWARM_LABEL ]; then
    JENKINS_SWARM_LABEL=docker
fi

if [ -z $JENKINS_SWARM_NAME ]; then
    JENKINS_SWARM_NAME=${JENKINS_SWARM_LABEL}
fi

if [ -z $JENKINS_SWARM_EXECUTORS ]; then
    JENKINS_SWARM_EXECUTORS=1
fi

JSW_HOME="/var/jenkins_home/${JENKINS_SWARM_NAME}"

mkdir -p "${JSW_HOME}"

# the Jenkins master may take some time before being up and running
sleep 30

java -jar ${SWARM_HOME}/swarm-client.jar \
  -deleteExistingClients \
  -disableSslVerification \
  -executors ${JENKINS_SWARM_EXECUTORS} \
  -master ${JENKINS_MASTER_URL} \
  -name ${JENKINS_SWARM_NAME} \
  -labels ${JENKINS_SWARM_LABEL} \
  -tunnel 127.0.0.1:50000 \
  -fsroot "${JSW_HOME}" \
  -username swarm \
  -password ${SWARM_PWD} 2>&1 > ${SWARM_HOME}/swarm-client.log

