package ar.edu.heladeria.application

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication
class HeladeriaApplication {
	def static void main(String[] args) {
		val bootstrap = new HeladeriaBootstrap
		bootstrap.initHeladerias()
		SpringApplication.run(HeladeriaApplication, args)
	}
}
