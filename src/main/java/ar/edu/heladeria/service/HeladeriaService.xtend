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
import graphql.schema.DataFetchingFieldSelectionSet
import io.leangen.graphql.annotations.GraphQLEnvironment
import io.leangen.graphql.annotations.GraphQLMutation
import io.leangen.graphql.annotations.GraphQLQuery
import io.leangen.graphql.execution.ResolutionEnvironment
import io.leangen.graphql.spqr.spring.annotations.GraphQLApi
import java.util.List
import javax.annotation.Nonnull
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@GraphQLApi
@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	DuenioService duenioService

	static final List<String> RELACIONES = #["duenio", "gustos"]

	@GraphQLQuery(name="todasLasHeladerias", description="Obtener todas las heladerías")
	@Nonnull
	def findAll(@GraphQLEnvironment ResolutionEnvironment env) {
		val entityGraph = env.dataFetchingEnvironment.selectionSet.entityGraph
		repoHeladeria.findAll(entityGraph).toList
	}

	@GraphQLQuery(name="buscarHeladerias", description="Buscar heladerías por nombre")
	@Nonnull
	def findByNombre(@Nonnull String nombre, @GraphQLEnvironment ResolutionEnvironment env) {
		val entityGraph = env.dataFetchingEnvironment.selectionSet.entityGraph
		repoHeladeria.findByNombreContaining(nombre, entityGraph)
	}

	@GraphQLQuery(name="heladeria", description="Obtener una heladería por id")
	@Nonnull
	def findById(@Nonnull Long heladeriaId, @GraphQLEnvironment ResolutionEnvironment env) {
		val entityGraph = env.dataFetchingEnvironment.selectionSet.entityGraph
		findById(heladeriaId, entityGraph)
	}

	def findById(Long heladeriaId, EntityGraph entityGraph) {
		repoHeladeria.findById(heladeriaId, entityGraph).orElseThrow([
			throw new NotFoundException("No se encontró la heladería indicada: " + heladeriaId.toString)
		])
	}

	def findCompletaById(Long heladeriaId) {
		val entityGraph = EntityGraphUtils.fromAttributePaths(RELACIONES)
		findById(heladeriaId, entityGraph)
	}

	def validarYGuardar(Heladeria heladeria) {
		heladeria.validar
		repoHeladeria.save(heladeria)
	}

	@GraphQLMutation(name="actualizarHeladeria", description="Actualizar uno o más atributos de una heladeria ")
	@Nonnull
	@Transactional
	def actualizar(@Nonnull HeladeriaActualizar heladeria) {
		val Heladeria heladeriaFound = findCompletaById(heladeria.id)
		heladeria.duenio = heladeria.duenio !== null ? duenioService.findById(heladeria.duenio.id) : heladeria.duenio
		heladeriaFound.merge(heladeria)
		validarYGuardar(heladeriaFound)
	}

	@GraphQLMutation(description="Agregar uno o más gustos a una heladería")
	@Transactional
	@Nonnull
	def agregarGustos(@Nonnull Long heladeriaId, @Nonnull List<GustoAgregar> gustos) {
		val Heladeria heladeria = findCompletaById(heladeriaId)
		heladeria.agregarGustos(gustos.map[toGusto].toList)
		validarYGuardar(heladeria)
	}

	@GraphQLMutation(description="Eliminar uno o más gustos de una heladería")
	@Transactional
	@Nonnull
	def eliminarGustos(@Nonnull Long heladeriaId, @Nonnull List<GustoEliminar> gustos) {
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
