
FROM openjdk:8-jre
ADD target/my-app-1.0-SNAPSHOT.jar app.jar
RUN apt-get update -y
EXPOSE 8020
ENTRYPOINT ["java","app.jar"]
