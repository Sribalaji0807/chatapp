# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY . .
RUN --mount=type=secret,id=SpringChatapp,dst=/etc/secrets/SpringChatapp.json \
    cat /etc/secrets/SpringChatapp.json
RUN mvn clean package -DskipTests


# Stage 2: Runtime (small image)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /src
COPY --from=builder /build/target/*.jar app.jar


EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
#CMD ["/bin/sh", "-c", "if [ -f /etc/secrets/SpringChatapp.json ]; then echo '✅ Secret found'; else echo '❌ Secret missing'; fi && java -jar app.jar"]

