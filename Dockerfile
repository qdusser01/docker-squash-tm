FROM tomcat:8-jre7
MAINTAINER Florian JUDITH <florian.judith.b@gmail.com>

ARG SQUASH_TM_LANGUAGE='en'

ENV TERM=xterm

ENV SQUASH_TM_VERSION=1.15.0
ENV CATALINA_HOME /usr/local/tomcat
ENV JAVA_OPTS="-Xmx1024m -XX:MaxPermSize=256m"

RUN apt-get -y update && apt-get -y install \
	postgresql-client \
	mysql-client \
	xmlstarlet \
	nano 

RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost

COPY conf/squash-tm.xml /usr/local/tomcat/conf/Catalina/localhost/squash-tm.xml

COPY conf/install_squash-tm.sh /tmp/install_squash-tm.sh
RUN chmod +x /tmp/install_squash-tm.sh
RUN exec /tmp/install_squash-tm.sh

# Copy WAR to webapps
RUN cp /usr/share/squash-tm/bundles/squash-tm.war $CATALINA_HOME/webapps/

COPY docker-entrypoint.sh /usr/share/squash-tm/bin/docker-entrypoint.sh
RUN chmod +x /usr/share/squash-tm/bin/docker-entrypoint.sh

COPY conf/log4j.properties /usr/share/squash-tm/bin/conf

EXPOSE 8080

WORKDIR $CATALINA_HOME
ENTRYPOINT ["/usr/share/squash-tm/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]