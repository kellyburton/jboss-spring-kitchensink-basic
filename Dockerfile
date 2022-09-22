FROM maven:latest as stage-build
WORKDIR /tmp
ADD jboss-eap-quickstarts /tmp/jboss-eap-quickstarts
##COPY jboss-eap-quickstarts/spring-kitchensink-basic /app/jboss-eap-quickstarts/spring-kitchensink-basic/
RUN mvn package  -f /tmp/jboss-eap-quickstarts/spring-kitchensink-basic/pom.xml


FROM quay.io/wildfly/wildfly as stage-deploy
RUN /opt/jboss/wildfly/bin/add-user.sh admin saTX##321 --silent
COPY --from=stage-build  /tmp/jboss-eap-quickstarts/spring-kitchensink-basic/target/spring-kitchensink-basic.war /opt/jboss/wildfly/standalone/deployments/spring-kitchensink-basic.war
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
#EXPOSE 8080
#EXPOSE 9990
