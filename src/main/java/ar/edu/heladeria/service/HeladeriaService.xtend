package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.input.GustoAgregarInput
import ar.edu.heladeria.input.GustoEliminarInput
import ar.edu.heladeria.input.HeladeriaActualizarInput
import ar.edu.heladeria.repos.RepoHeladeria
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphUtils
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphs
import graphql.schema.DataFetchingFieldSelectionSet
import java.util.List
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	DuenioService duenioService

	static final List<String> RELACIONES = #["duenio", "gustos"]

	def findAll(DataFetchingFieldSelectionSet atributosSeleccionados) {
		val entityGraph = atributosSeleccionados.entityGraph
		repoHeladeria.findAll(entityGraph).toList
	}

	def findByNombre(String nombre, DataFetchingFieldSelectionSet atributosSeleccionados) {
		val entityGraph = atributosSeleccionados.entityGraph
		repoHeladeria.findByNombreContaining(nombre, entityGraph)
	}

	def findById(Long heladeriaId, EntityGraph entityGraph) {
		repoHeladeria.findById(heladeriaId, entityGraph).orElseThrow([
			throw new NotFoundException("No se encontró la heladería indicada: " + heladeriaId.toString)
		])
	}

	def findById(Long heladeriaId, DataFetchingFieldSelectionSet atributosSeleccionados) {
		val entityGraph = atributosSeleccionados.entityGraph
		findById(heladeriaId, entityGraph)
	}

	def findCompletaById(Long heladeriaId) {
		val entityGraph = EntityGraphUtils.fromAttributePaths(RELACIONES)
		findById(heladeriaId, entityGraph)
	}

	def validarYGuardar(Heladeria heladeria) {
		heladeria.validar
		repoHeladeria.save(heladeria)
	}

	@Transactional
	def actualizar(HeladeriaActualizarInput heladeria) {
		val Heladeria heladeriaFound = findCompletaById(heladeria.id)
		heladeria.duenio = heladeria.duenio !== null ? duenioService.findById(heladeria.duenio.id) : heladeria.duenio
		heladeriaFound.merge(heladeria)
		validarYGuardar(heladeriaFound)
	}

	@Transactional
	def agregarGustos(Long heladeriaId, List<GustoAgregarInput> gustos) {
		val Heladeria heladeria = findCompletaById(heladeriaId)
		heladeria.agregarGustos(gustos.map[toGusto].toList)
		validarYGuardar(heladeria)
	}

	@Transactional
	def eliminarGustos(Long heladeriaId, List<GustoEliminarInput> gustos) {
		val Heladeria heladeria = findCompletaById(heladeriaId)
		gustos.forEach[gustoAEliminar|heladeria.eliminarGusto(gustoAEliminar.toGusto)]
		validarYGuardar(heladeria)
	}

	def getEntityGraph(DataFetchingFieldSelectionSet atributosSeleccionados) {
		val relaciones = RELACIONES.filter[relacion|atributosSeleccionados.contains(relacion)].toList
		val entityGraph = relaciones.empty ? EntityGraphs.empty : EntityGraphUtils.fromAttributePaths(relaciones)
		return entityGraph
	}

}
