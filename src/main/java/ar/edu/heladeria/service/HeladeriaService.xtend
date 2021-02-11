package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.repos.RepoHeladeria
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.uqbar.commons.model.exceptions.UserException
import java.util.Map

@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	DuenioService duenioService
	
	def findAll() {
		repoHeladeria.findAll().toList
	}

	def findByNombre(String nombre) {
		repoHeladeria.findByNombreContaining(nombre)
	}
	
	def findById(Long heladeriaId) {
		repoHeladeria.findById(heladeriaId).orElseThrow([
			throw new UserException("No se encontró la heladería indicada: " + heladeriaId.toString)
		]);
	}

	def validarYGuardar(Heladeria heladeria) {
		heladeria.validar
		repoHeladeria.save(heladeria)
	}

	def asignarDuenio(Long heladeriaId, Duenio duenio) {
		val Heladeria heladeria = findById(heladeriaId)
		heladeria.duenio = duenioService.findById(duenio.id)
		validarYGuardar(heladeria)
	}
	
	def actualizar(Long heladeriaId, Heladeria heladeria) {
		val Heladeria heladeriaFound = findById(heladeriaId)
		heladeriaFound.merge(heladeria)
		validarYGuardar(heladeriaFound)
	}

	def agregarGustos(Long heladeriaId, Map<String, Integer> gustos) {
		val Heladeria heladeria = findById(heladeriaId)
		heladeria.agregarGustos(gustos)
		validarYGuardar(heladeria)
	}

	def eliminarGustos(Long heladeriaId, Map<String, Integer> gustos) {
		val Heladeria heladeria = findById(heladeriaId)
		gustos.forEach[gusto, _|heladeria.eliminarGusto(gusto)]
		validarYGuardar(heladeria)
	}

}
