plugins {
    kotlin("jvm") version "1.8.20"
    id("io.ktor.plugin") version "2.3.0"
    id("com.github.johnrengelman.shadow") version "7.1.2"
    kotlin("plugin.serialization") version "1.8.20"
}

group = "com.rgv"
version = "1.0-SNAPSHOT"

kotlin {
    jvmToolchain(17)
}

repositories {
    mavenCentral()
}

application {
    mainClass.set("com.rgv.ApplicationKt")
}

dependencies {
    implementation("ch.qos.logback:logback-classic:1.4.14")

    val ktorVersion = "2.3.0"
    implementation("io.ktor:ktor-server-core:$ktorVersion")
    implementation("io.ktor:ktor-server-auth:$ktorVersion")
    implementation("io.ktor:ktor-server-auth-jwt:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
    implementation("io.ktor:ktor-server-netty:$ktorVersion")
    implementation("io.ktor:ktor-server-status-pages:$ktorVersion")
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")

    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.5.0")
    implementation("org.jetbrains.exposed:exposed-core:0.40.1")
    implementation("org.jetbrains.exposed:exposed-jdbc:0.40.1")

    implementation("com.mysql:mysql-connector-j:8.2.0")
    implementation("org.mariadb.jdbc:mariadb-java-client:3.1.2")
}

tasks.withType<Jar> {
    manifest {
        attributes(
            mapOf(
                "Main-Class" to application.mainClass.get()
            )
        )
    }
}

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    archiveFileName.set("fat.jar")
}