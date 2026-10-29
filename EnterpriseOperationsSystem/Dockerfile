
FROM tomcat:9.0-jdk8-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN apt-get update \
    && apt-get install -y maven \
    && mvn clean package -DskipTests \
    && cp target/enterprise-operations.war /usr/local/tomcat/webapps/ROOT.war \
    && rm -rf /var/lib/apt/lists/*

# Configure Tomcat to use Render's assigned port
RUN sed -i 's/port="8080"/port="${port}"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
