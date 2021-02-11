package ar.edu.heladeria.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import ar.edu.heladeria.service.HeladeriaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.service.DuenioService
import org.springframework.web.bind.annotation.PatchMapping

@RestController
class HeladeriaController {

	@Autowired
	HeladeriaService heladeriaService
	@Autowired
	DuenioService duenioService

	@GetMapping("/heladerias")
	def getHeladerias() {
		return heladeriaService.findAll.toList
	}

	@GetMapping("/heladerias/{nombre}")
	def buscarHeladeria(@PathVariable String nombre) {
		return heladeriaService.findByNombre(nombre)
	}

	@GetMapping("/duenios")
	def getDuenios() {
		return duenioService.findAll.toList
	}

	@PostMapping("/duenios/crear")
	def crearDuenio(@RequestBody Duenio duenio) {
		duenioService.crear(duenio)
	}

	@PatchMapping("/heladerias/{heladeriaId}/asignarDuenio")
	def asginarDuenio(@RequestBody Duenio duenio, @PathVariable Long heladeriaId) {
		heladeriaService.asignarDuenio(heladeriaId, duenio)
	}

}
