package com.rgv.plugins

import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

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