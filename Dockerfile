FROM tomcat:9.0.31-jdk11-openjdk

WORKDIR $CATALINA_HOME

ENV CMDBUILD_URL https://sourceforge.net/projects/cmdbuild/files/ready2use-2.0/Core%20updates/ready2use-2.0-3.3/ready2use-2.0-3.3.war/download
ENV POSTGRES_CMDBUILD_USER cmdbuild
ENV POSTGRES_CMDBUILD_PASS cmdbuild
ENV POSTGRES_USER postgres
ENV POSTGRES_PASS postgres
ENV POSTGRES_PORT 5432
ENV POSTGRES_HOST localhost
ENV POSTGRES_DB cmdbuild_r2u2
ENV CMDBUILD_DUMP empty.dump.xz

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    maven \
	postgresql-client

RUN set -x \
 	&& mkdir $CATALINA_HOME/conf/cmdbuild/ \
 	&& mkdir $CATALINA_HOME/webapps/cmdbuild/

COPY files/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY files/context.xml $CATALINA_HOME/webapps/manager/META-INF/context.xml
COPY files/database.conf $CATALINA_HOME/conf/cmdbuild/database.conf
COPY files/docker-entrypoint.sh /usr/local/bin/


RUN set -x \
	&& groupadd tomcat \
	&& useradd -s /bin/false -g tomcat -d $CATALINA_HOME tomcat \
	&& cd /tmp \
	&& wget --no-check-certificate -O cmdbuild.war "$CMDBUILD_URL" \
	&& chmod 777 cmdbuild.war \
	&& chmod 777 /usr/local/bin/docker-entrypoint.sh \
	&& unzip cmdbuild.war -d cmdbuild \
	&& mv cmdbuild.war $CATALINA_HOME/webapps/cmdbuild.war \
	&& mv cmdbuild/* $CATALINA_HOME/webapps/cmdbuild/ \
	&& chmod 777 $CATALINA_HOME/webapps/cmdbuild/cmdbuild.sh \
	&& chown tomcat -R $CATALINA_HOME \
	&& cd /tmp \
	&& rm -rf * \
	&& rm -rf /var/lib/apt/lists/*

# cleanup
RUN apt-get -qy autoremove

ENTRYPOINT /usr/local/bin/docker-entrypoint.sh

USER tomcat

EXPOSE 8080

CMD ["catalina.sh", "run"]
