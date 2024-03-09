FROM openjdk:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ./target/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar","/app.jar"]


FROM openjdk:17
RUN apt-get update && apt-get install -y maven
COPY . /app
WORKDIR /app
RUN mvn clean package
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/target/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar"]


FROM maven:3.8.5-openjdk-17 as base
WORKDIR /app
COPY . /app
RUN mvn clean package -Dmaven.test.skip=true
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/target/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar"]





#Stage 1
FROM maven:3.8.5-openjdk-17 as stage1
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY ./src ./src
RUN mvn clean install -Dmaven.test.skip=true
#Stage 2
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY --from=stage1 /app/target/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/spring-boot-ecommerce-0.0.1-SNAPSHOT.jar"]