package ar.edu.heladeria.controller

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import io.swagger.annotations.ApiOperation
import java.util.Map
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import ar.edu.heladeria.serializer.HeladeriaDTO

@RestController
@CrossOrigin
class HeladeriaController {

	@Autowired
	HeladeriaService heladeriaService
	@Autowired
	DuenioService duenioService

	@GetMapping("/heladerias/buscar")
	@ApiOperation(value="Todas las heladerías", notes="Devuelve los datos de todas las heladerías. De cada una se incluye su dueño.")
	def getHeladerias() {
		return heladeriaService.findAll.map[HeladeriaDTO.fromHeladeria(it)]
	}

	@GetMapping("/heladerias/buscar/{nombre}")
	@ApiOperation(value="Buscar heladerías por nombre", notes="Devuelve los datos de las heladerías que contengan en su nombre el string recibido. De cada una se incluye su dueño.")
	def buscarHeladeria(@PathVariable String nombre) {
		return heladeriaService.findByNombre(nombre).map[HeladeriaDTO.fromHeladeria(it)]
	}

	@GetMapping("/heladerias/id/{id}")
	@ApiOperation(value="Heladeria por id", notes="Trae la información de una heladería en base a su id, incluyendo su dueño y gustos.")
	def getHeladeriaById(@PathVariable Long id) {
		return heladeriaService.findById(id)
	}

	@GetMapping("/duenios")
	@ApiOperation(value="Todos los dueños", notes="Devuelve la información de todos los dueños.")
	def getDuenios() {
		return duenioService.findAll
	}

	@PostMapping("/duenios")
	@ApiOperation(value="Crear dueño", notes="Permite guardar un nuevo dueño.")
	def crearDuenio(@RequestBody Duenio duenio) {
		duenioService.validarYGuardar(duenio)
	}

	@PatchMapping("/heladerias/{heladeriaId}")
	@ApiOperation(value="Actualizar heladería", notes="Permite actualizar uno o varios atributos de una heladería.")
	def actualizarHeladeria(@RequestBody Heladeria heladeria, @PathVariable Long heladeriaId) {
		heladeriaService.actualizar(heladeriaId, heladeria)
	}

	@PostMapping("/heladerias/{heladeriaId}/gustos")
	@ApiOperation(value="Agregar gustos", notes="Permite agregar uno o más gustos a una heladería.")
	def agregarGustos(@RequestBody Map<String, Integer> gustos, @PathVariable Long heladeriaId) {
		heladeriaService.agregarGustos(heladeriaId, gustos)
	}

	@DeleteMapping("/heladerias/{heladeriaId}/gustos")
	@ApiOperation(value="Eliminar gustos", notes="Permite eliminar uno o más gustos de una heladería.")
	def eliminarGustos(@RequestBody Map<String, Integer> gustos, @PathVariable Long heladeriaId) {
		heladeriaService.eliminarGustos(heladeriaId, gustos)
	}

}
