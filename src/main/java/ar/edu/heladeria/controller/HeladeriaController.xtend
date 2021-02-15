package ar.edu.heladeria.controller

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.Map
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.CrossOrigin

@RestController
@CrossOrigin
class HeladeriaController {

	@Autowired
	HeladeriaService heladeriaService
	@Autowired
	DuenioService duenioService

	@GetMapping("/heladerias/buscar")
	def getHeladerias() {
		return heladeriaService.findAll.toList
	}

	@GetMapping("/heladerias/buscar/{nombre}")
	def buscarHeladeria(@PathVariable String nombre) {
		return heladeriaService.findByNombre(nombre)
	}

	@GetMapping("/heladerias/id/{id}")
	def getHeladeriaById(@PathVariable Long id) {
		return heladeriaService.findById(id)
	}

	@GetMapping("/duenios")
	def getDuenios() {
		return duenioService.findAll.toList
	}

	@PostMapping("/duenios/crear")
	def crearDuenio(@RequestBody Duenio duenio) {
		duenioService.validarYGuardar(duenio)
	}

	@PatchMapping("/heladerias/{heladeriaId}/asignarDuenio")
	def asginarDuenio(@RequestBody Duenio duenio, @PathVariable Long heladeriaId) {
		heladeriaService.asignarDuenio(heladeriaId, duenio)
	}

	@PatchMapping("/heladerias/{heladeriaId}/actualizar")
	def actualizarHeladeria(@RequestBody Heladeria heladeria, @PathVariable Long heladeriaId) {
		heladeriaService.actualizar(heladeriaId, heladeria)
	}

	@PostMapping("/heladerias/{heladeriaId}/agregarGustos")
	def agregarGustos(@RequestBody Map<String, Integer> gusto, @PathVariable Long heladeriaId) {
		heladeriaService.agregarGustos(heladeriaId, gusto)
	}

	@DeleteMapping("/heladerias/{heladeriaId}/eliminarGustos")
	def eliminarGustos(@RequestBody Map<String, Integer> gusto, @PathVariable Long heladeriaId) {
		heladeriaService.eliminarGustos(heladeriaId, gusto)
	}

}
