
FROM tomcat:9.0-jdk8-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY java ./java

RUN apt-get update \
    && apt-get install -y maven \
    && mvn clean package -DskipTests \
    && cp target/enterprise-operations.war /usr/local/tomcat/webapps/ROOT.war \
    && rm -rf /var/lib/apt/lists/*

CMD ["sh", "-c", "export CATALINA_OPTS='-Xms64m -Xmx256m -XX:MaxMetaspaceSize=128m'; sed -i 's/port=\"8005\"/port=\"-1\"/' /usr/local/tomcat/conf/server.xml && sed -i '/<Connector port=\"8080\"/s/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
