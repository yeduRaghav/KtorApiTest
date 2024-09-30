FROM gradle:7.6.1-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle buildFatJar --no-daemon --stacktrace

FROM eclipse-temurin:17-jre-jammy
EXPOSE 8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/fat.jar /app/ktor-docker-sample.jar
COPY --from=build /home/gradle/src/src/main/resources/application.conf /app/application.conf
CMD ["java", "-Dconfig.file=/app/application.conf", "-jar", "/app/ktor-docker-sample.jar"]