package com.rgv

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.config.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.json.Json


fun main(args: Array<String>) {

    val configFile = System.getProperty("config.resource", "application.conf")
    val environment = applicationEngineEnvironment {
        config = ApplicationConfig(configFile)
    }
    embeddedServer(Netty, environment).start(wait = true)
}

fun Application.module() {
    configureSerialization()
    configureErrorHandling()
    configureAuthentication()
    configureRouting()
    //configureDatabase()
}

fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json(Json {
            prettyPrint = true
            isLenient = false
        })
    }
}

fun Application.configureErrorHandling() {
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respondText(text = "500: $cause", status = HttpStatusCode.InternalServerError)
        }
    }
}


fun Application.configureAuthentication() {
    val jwtAudience = environment.config.propertyOrNull("jwt.audience")?.getString()
    val jwtRealm = environment.config.propertyOrNull("jwt.realm")?.getString()
    val jwtSecret = environment.config.propertyOrNull("jwt.secret")?.getString()
    val jwtIssuer = environment.config.propertyOrNull("jwt.issuer")?.getString()

    install(Authentication) {
        jwt {
            realm = jwtRealm ?: "Ktor Server"
            verifier(
                JWT
                    .require(Algorithm.HMAC256(jwtSecret ?: "secret"))
                    .withAudience(jwtAudience ?: "jwt-audience")
                    .withIssuer(jwtIssuer ?: "http://0.0.0.0:8080/")
                    .build()
            )
            validate { credential ->
                if (credential.payload.audience.contains(jwtAudience)) JWTPrincipal(credential.payload) else null
            }
        }
    }

}

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("Hello World!")
        }
        authenticate {
            get("/protected") {
                call.respondText("Access granted tp protected resource")
            }
        }
    }
}

//fun Application.configureDatabase() {
//    val dbUrl = environment.config.property("database.url").getString()
//    val dbUser = environment.config.property("database.user").getString()
//    val dbPassword = environment.config.property("database.password").getString()
//
//    // TODO: Fix me in future
//    //Database.connect(dbUrl, driver = "org.mariadb.jdbc.Driver", user = dbUser, password = dbPassword)
//}
