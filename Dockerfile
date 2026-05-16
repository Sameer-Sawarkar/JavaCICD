FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY target/javacicd-1.0.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java","-jar","/app/app.jar","--server.port=8081"]
