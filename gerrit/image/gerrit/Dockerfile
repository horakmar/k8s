FROM openfrontier/gerrit:latest

# Overridable defaults
ENV GERRIT_HOME /var/gerrit
ENV GERRIT_SITE ${GERRIT_HOME}/review_site
ENV GERRIT_WAR ${GERRIT_HOME}/gerrit.war
ENV GERRIT_VERSION 2.14.7
ENV GERRIT_USER gerrit2
ENV GERRIT_INIT_ARGS ""

RUN ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime

COPY gerrit-entrypoint.sh /
