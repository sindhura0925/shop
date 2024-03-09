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