FROM gradle:7.6.1-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle buildFatJar --no-daemon --stacktrace

FROM eclipse-temurin:17-jre-jammy
EXPOSE 8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/fat.jar /app/ktor-docker-sample.jar
COPY --from=build /home/gradle/src/src/main/resources/*.conf /app/
ENV CONFIG_FILE=/app/application.conf
CMD ["sh", "-c", "java -Dconfig.file=$CONFIG_FILE -jar /app/ktor-docker-sample.jar"]