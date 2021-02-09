package ar.edu.heladeria.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import ar.edu.heladeria.service.HeladeriaService
import org.springframework.beans.factory.annotation.Autowired

@RestController
class HeladeriaController {

	@Autowired
	HeladeriaService heladeriaService

	@GetMapping("/heladerias")
	def getHeladerias() {
		return heladeriaService.findAll.toList
	}
	
	@GetMapping("/duenio/:heladeriaId")
	def getDuenio() {
		return heladeriaService.findAll.toList
	}
	
	
}
