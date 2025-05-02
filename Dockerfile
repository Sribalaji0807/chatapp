# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Runtime (small image)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /src
CMD ["/bin/sh", "-c", "if [ -f /etc/secrets/SpringChatapp.json ]; then echo '✅ File exists'; else echo '❌ File NOT found'; fi"]
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
#ENTRYPOINT ["java", "-jar", "app.jar"]
