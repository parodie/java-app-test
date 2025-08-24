# Stage 1: Build the app using Maven
FROM maven:3.8.5-openjdk-17-slim AS builder

WORKDIR /app

# Copy pom.xml first (to cache dependencies)
COPY pom.xml .

# Copy source code
COPY src ./src

# Build the JAR (skip tests in CI)
RUN mvn package -DskipTests

# Stage 2: Run the app with a lightweight JRE
FROM openjdk:17-jre-slim

WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]