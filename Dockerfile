FROM openjdk:17
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

#FROM tomcat:latest
#RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
#COPY ./*.war /usr/local/tomcat/webapps
