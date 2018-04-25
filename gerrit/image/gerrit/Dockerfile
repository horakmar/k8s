FROM openfrontier/gerrit:latest

# Overridable defaults
ENV GERRIT_HOME /var/gerrit
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_VERSION 2.14.7
ENV GERRIT_USER gerrit2
ENV GERRIT_INIT_ARGS ""

RUN ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime

COPY files/gerrit-entrypoint.sh /
COPY files/gerrit-create-user.sh /usr/local/bin/gerrit-create-user.sh
COPY files/gerrit-upload-ssh-key.sh /usr/local/bin/gerrit-upload-ssh-key.sh
COPY files/gerrit-init.nohup /docker-entrypoint-init.d/gerrit-init.nohup
RUN chmod +x /usr/local/bin/*.sh /docker-entrypoint-init.d/gerrit-init.nohup
