# Build Stage
FROM gradle:8.5-jdk17 AS builder

WORKDIR /build

COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon

COPY src src
RUN ./gradlew bootJar --no-daemon

# Run Stage
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY --from=builder /build/build/libs/*.jar app.jar

EXPOSE 29081

ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=local"]