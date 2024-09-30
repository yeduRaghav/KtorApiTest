package com.rgv

import com.rgv.plugins.configureAuthentication
import com.rgv.plugins.configureErrorHandling
import com.rgv.plugins.configureRouting
import com.rgv.plugins.configureSerialization
import io.ktor.server.engine.*
import io.ktor.server.netty.*


fun main() {
    embeddedServer(Netty, System.getenv("PORT")?.toInt() ?: 8080, host = "0.0.0.0") {
        configureSerialization()
        configureAuthentication()
        configureErrorHandling()
        configureRouting()
    }.start(wait = true)
}