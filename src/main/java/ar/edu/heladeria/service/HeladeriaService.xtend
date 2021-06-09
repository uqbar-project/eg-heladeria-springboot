package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Gusto
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.input.ActualizarHeladeriaInput
import ar.edu.heladeria.repos.RepoHeladeria
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph
import java.util.Set
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	DuenioService duenioService

	def findAll(EntityGraph entityGraph) {
		repoHeladeria.findAll(entityGraph).toList
	}

	def findByNombre(String nombre, EntityGraph entityGraph) {
		repoHeladeria.findByNombreContaining(nombre, entityGraph)
	}

	def findById(Long heladeriaId, EntityGraph entityGraph) {
		repoHeladeria.findById(heladeriaId, entityGraph).orElseThrow([
			throw new NotFoundException("No se encontró la heladería indicada: " + heladeriaId.toString)
		])
	}

	def validarYGuardar(Heladeria heladeria) {
		heladeria.validar
		repoHeladeria.save(heladeria)
	}

	@Transactional
	def actualizar(ActualizarHeladeriaInput heladeria, EntityGraph entityGraph) {
		val Heladeria heladeriaFound = findById(heladeria.id, entityGraph)
		heladeria.duenio = heladeria.duenio !== null ? duenioService.findById(heladeria.duenio.id) : heladeria.duenio
		heladeriaFound.merge(heladeria)
		validarYGuardar(heladeriaFound)
	}

	@Transactional
	def agregarGustos(Long heladeriaId, Set<Gusto> gustos, EntityGraph entityGraph) {
		val Heladeria heladeria = findById(heladeriaId, entityGraph)
		heladeria.agregarGustos(gustos)
		validarYGuardar(heladeria)
	}

	@Transactional
	def eliminarGustos(Long heladeriaId, Set<Gusto> gustos, EntityGraph entityGraph) {
		val Heladeria heladeria = findById(heladeriaId, entityGraph)
		gustos.forEach[gusto|heladeria.eliminarGusto(gusto)]
		validarYGuardar(heladeria)
	}

}
