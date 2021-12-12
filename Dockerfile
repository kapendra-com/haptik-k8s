FROM centos

MAINTAINER kapendra@kapendra.com

RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
RUN curl -O https://downloads.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz
RUN tar xvfz apache*.tar.gz
RUN mv apache-tomcat-8.5.73/* /opt/tomcat/.
RUN yum -y install java
RUN java -version
WORKDIR /opt/tomcat/webapps
COPY SampleWebApp.war entrypoint.sh ./
RUN chmod +x entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/opt/tomcat/webapps/entrypoint.sh"]