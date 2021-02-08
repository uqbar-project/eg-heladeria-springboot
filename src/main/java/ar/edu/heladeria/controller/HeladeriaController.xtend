package ar.edu.heladeria.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HeladeriaController {

	@GetMapping("/")
	def saludo() {
		return "asd"
	}
}
