# no minor and major upgrade by image name!!
FROM jboss/keycloak:13.0.1

ENV KEYCLOAK_LOGLEVEL=INFO
ENV ROOT_LOGLEVEL=INFO
ENV KEYCLOAK_DIRECTORY=${JBOSS_HOME}
ENV PROXY_ADDRESS_FORWARDING=false
ENV FRONTEND_URL=https://<YOUR-APP-SERVICE-NAME>.azurewebsites.net/auth/

EXPOSE 8080 2222

USER root

RUN mkdir -p /tmp/setup/ssh
COPY ssh/* /tmp/setup/ssh/
COPY bin/* /usr/local/bin/

#setup SSH
ENV SSH_PASSWD "root:Docker!"
RUN microdnf -y install yum && yum install -y procps && yum install -y openssh && yum install -y wget \
      && cd /tmp/setup/ssh/ && wget https://rpmfind.net/linux/centos/8/BaseOS/x86_64/os/Packages/openssh-server-8.0p1-10.el8.x86_64.rpm \
      && yum install -y openssh-server-8.0p1-10.el8.x86_64.rpm \
      && cp /tmp/setup/ssh/sshd_config /etc/ssh/ \
      && echo "$SSH_PASSWD" | chpasswd \
      && cd /etc/ssh/ && ssh-keygen -A \
      && chmod 600 /etc/ssh/* \
      && chmod 644 /etc/ssh/*.pub \
      && chmod 700 /etc/ssh

# Upgrade packages
RUN microdnf -y update && microdnf clean all && rm -rf /tmp/setup && rm -rf /var/cache/yum

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

USER 1000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]