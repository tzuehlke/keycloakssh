#!/bin/bash

if [ ${PROXY_ADDRESS_FORWARDING} = true ];
then
    export JAVA_OPTS_APPEND="-Dkeycloak.frontendUrl=${FRONTEND_URL}" 
    # Configure start profile
    sed -i 's/name="forceBackendUrlToFrontendUrl" value="false"/name="forceBackendUrlToFrontendUrl" value="true"/' /opt/jboss/keycloak/standalone/configuration/standalone.xml
fi;

# start ssh as root
#/usr/sbin/sshd
su - root <<!
Docker!
/usr/sbin/sshd
!

# start orginal launcher
/opt/jboss/tools/docker-entrypoint.sh -c standalone.xml
