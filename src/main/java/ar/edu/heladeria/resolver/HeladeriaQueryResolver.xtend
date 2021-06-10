package ar.edu.heladeria.resolver

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import graphql.kickstart.tools.GraphQLQueryResolver
import graphql.schema.DataFetchingEnvironment
import java.util.List
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

import static ar.edu.heladeria.resolver.EntityGraphHelpers.*

@Component
class HeladeriaQueryResolver implements GraphQLQueryResolver {

	@Autowired
	HeladeriaService heladeriaService

	@Autowired
	DuenioService duenioService

	def List<Heladeria> buscarHeladerias(String nombre, DataFetchingEnvironment enviroment) {
		return heladeriaService.findByNombre(nombre, fromSelectionSet(enviroment.selectionSet))
	}

	def List<Heladeria> todasLasHeladerias(DataFetchingEnvironment enviroment) {
		return heladeriaService.findAll(fromSelectionSet(enviroment.selectionSet))
	}

	def Heladeria heladeria(Long id, DataFetchingEnvironment enviroment) {
		return heladeriaService.findById(id, fromSelectionSet(enviroment.selectionSet))
	}

	def List<Duenio> duenios() {
		return duenioService.findAll
	}

}
