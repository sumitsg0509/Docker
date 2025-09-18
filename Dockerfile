# Stage 1: build/compile
FROM maven:3.9.0-eclipse-temurin-17 AS builder
ARG GIT_COMMIT
ARG BUILD_ID
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Optional: embed build metadata as labels or in manifest
RUN mvn -B -DskipTests package

# Stage 2: final runtime (slim)
FROM eclipse-temurin:17-jre-jammy
LABEL maintainer="you@example.com"
WORKDIR /app
# copy only the jar (adjust artifact path)
COPY --from=builder /app/target/*.jar /app/app.jar
# metadata (optional)
ARG GIT_COMMIT
ARG BUILD_ID
ENV GIT_COMMIT=${GIT_COMMIT} BUILD_ID=${BUILD_ID}
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
