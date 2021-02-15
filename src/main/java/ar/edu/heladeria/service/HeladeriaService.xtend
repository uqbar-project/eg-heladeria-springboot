package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.repos.RepoHeladeria
import java.util.Map
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.uqbar.commons.model.exceptions.UserException

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

	def actualizar(Long heladeriaId, Heladeria heladeria) {
		val Heladeria heladeriaFound = findById(heladeriaId)
		heladeria.duenio = duenioService.findById(heladeria.duenio.id)
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
		gustos.forEach[gusto, _ignore|heladeria.eliminarGusto(gusto)]
		validarYGuardar(heladeria)
	}

}
