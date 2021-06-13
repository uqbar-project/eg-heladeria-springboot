package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.input.GustoAgregar
import ar.edu.heladeria.input.GustoEliminar
import ar.edu.heladeria.input.HeladeriaActualizar
import ar.edu.heladeria.repos.RepoHeladeria
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphUtils
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphs
import com.fasterxml.jackson.databind.ObjectMapper
import graphql.schema.DataFetchingEnvironment
import graphql.schema.DataFetchingFieldSelectionSet
import java.util.LinkedHashMap
import java.util.List
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeladeriaService {

	static final ObjectMapper mapper = new ObjectMapper

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	DuenioService duenioService

	static final List<String> RELACIONES = #["duenio", "gustos"]

	def findAll() {
		return [ DataFetchingEnvironment enviroment |
			repoHeladeria.findAll(enviroment.selectionSet.toEntityGraph).toList
		]
	}

	def findByNombre() {
		return [ DataFetchingEnvironment enviroment |
			val nombre = enviroment.getArgument("nombre")
			repoHeladeria.findByNombreContaining(nombre, enviroment.selectionSet.toEntityGraph).toList
		]
	}

	def findById(Long heladeriaId, EntityGraph entityGraph) {
		return repoHeladeria.findById(heladeriaId, entityGraph).orElseThrow([
			throw new NotFoundException("No se encontró la heladería indicada: " + heladeriaId.toString)
		])
	}

	def findById() {
		return [ DataFetchingEnvironment enviroment |
			val heladeriaId = Long.parseLong(enviroment.getArgument("id"))
			val entityGraph = enviroment.selectionSet.toEntityGraph
			findById(heladeriaId, entityGraph)
		]
	}

	def findCompletaById(Long heladeriaId) {
		return findById(heladeriaId, EntityGraphUtils.fromAttributePaths(RELACIONES))
	}

	def validarYGuardar(Heladeria heladeria) {
		heladeria.validar
		repoHeladeria.save(heladeria)
	}

	@Transactional
	def actualizar() {
		return [ DataFetchingEnvironment enviroment |
			val heladeria = mapper.convertValue(enviroment.getArgument("heladeria"), HeladeriaActualizar)
			val Heladeria heladeriaFound = findCompletaById(heladeria.id)
			heladeria.duenio = heladeria.duenio !== null ? duenioService.findById(heladeria.duenio.id) : heladeria.
				duenio
			heladeriaFound.merge(heladeria)
			validarYGuardar(heladeriaFound)
		]
	}

	@Transactional
	def agregarGustos() {
		return [ DataFetchingEnvironment enviroment |
			val heladeriaId = Long.parseLong(enviroment.getArgument("heladeriaId"))
			val Heladeria heladeria = findCompletaById(heladeriaId)
			val List<GustoAgregar> gustos = HeladeriaService.convertirLista(enviroment.getArgument("gustos"),
				GustoAgregar)
			heladeria.agregarGustos(gustos.map[toGusto].toList)
			validarYGuardar(heladeria)
		]
	}

	@Transactional
	def eliminarGustos() {
		return [ DataFetchingEnvironment enviroment |
			val heladeriaId = Long.parseLong(enviroment.getArgument("heladeriaId"))
			val Heladeria heladeria = findCompletaById(heladeriaId)
			val List<GustoEliminar> gustos = HeladeriaService.convertirLista(enviroment.getArgument("gustos"),
				GustoEliminar)
			gustos.forEach[gustoAEliminar|heladeria.eliminarGusto(gustoAEliminar.toGusto)]
			validarYGuardar(heladeria)
		]
	}

	def toEntityGraph(DataFetchingFieldSelectionSet atributosSeleccionados) {
		val relaciones = RELACIONES.filter[relacion|atributosSeleccionados.contains(relacion)].toList
		val entityGraph = relaciones.empty ? EntityGraphs.empty : EntityGraphUtils.fromAttributePaths(relaciones)
		return entityGraph
	}

	static def <T extends Object> List<T> convertirLista(List<LinkedHashMap<String, String>> json,
		Class<T> expectedType) {
		val type = mapper.getTypeFactory().constructCollectionType(List, expectedType)
		mapper.convertValue(json, type)
	}

}
