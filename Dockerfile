# STAGE 1: Build the WAR file using Maven
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# STAGE 2: Deploy the WAR file to a standard Tomcat server
FROM tomcat:9.0-jdk21-temurin

# 1단계(builder)에서 빌드된 .war 파일을 Tomcat의 webapps 폴더에 ROOT.war 라는 이름으로 복사합니다.
# 이렇게 하면 웹사이트의 기본 경로(/)로 바로 접속할 수 있습니다.
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat 서버는 8080 포트를 사용합니다.
EXPOSE 8080

# Tomcat 이미지는 기본적으로 서버를 실행하는 CMD가 내장되어 있어 별도로 적을 필요가 없습니다.
