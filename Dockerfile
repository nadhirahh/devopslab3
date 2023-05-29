# # Use a base image with Java and the desired version
# FROM adoptopenjdk:11-jdk-hotspot

# # Set the working directory inside the container
# WORKDIR /app

# # Copy the compiled JAR file and dependencies into the container
# COPY target/serving-web-content-complete-0.0.1-SNAPSHOT.jar app.jar

# # Expose the port that your Spring Boot application listens on (default is 8080)
# EXPOSE 8082

# # Set the command to run your Spring Boot application when the container starts
# CMD ["mvn", "-cp", "app.jar", "com.example.servingwebcontent.ServingWebContentApplication"]

#
# Build stage
#
FROM maven:3.8.3-openjdk-17 AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM openjdk:17-jdk-slim
COPY --from=build /home/app/target/serving-web-content-complete-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]