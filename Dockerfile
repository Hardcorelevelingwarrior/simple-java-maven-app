
FROM openjdk:8-jre
ADD target/my-app-1.0-SNAPSHOT.jar /usr/local/lib/demo.jar
RUN apt-get update -y
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar",]
