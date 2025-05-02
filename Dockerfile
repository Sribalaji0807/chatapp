# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests


# Stage 2: Runtime (small image)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /src
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
#ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["/bin/sh", "-c", "if [ -f /etc/secrets/SpringChatapp.json ]; then echo '✅ Secret found'; else echo '❌ Secret missing'; fi && java -jar app.jar"]

