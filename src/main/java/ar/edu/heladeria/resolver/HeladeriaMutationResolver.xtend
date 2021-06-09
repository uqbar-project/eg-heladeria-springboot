package ar.edu.heladeria.resolver

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Gusto
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.input.ActualizarHeladeriaInput
import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import graphql.kickstart.tools.GraphQLMutationResolver
import graphql.schema.DataFetchingEnvironment
import java.util.Set
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

import static ar.edu.heladeria.resolver.ResolverHelpers.*

@Component
class HeladeriaMutationResolver implements GraphQLMutationResolver {

	@Autowired
	HeladeriaService heladeriaService

	@Autowired
	DuenioService duenioService

	def Heladeria actualizarHeladeria(ActualizarHeladeriaInput heladeriaInput, DataFetchingEnvironment enviroment) {
		return heladeriaService.actualizar(heladeriaInput, entityGraph(enviroment.selectionSet))
	}

	def Duenio crearDuenio(Duenio duenioInput) {
		return duenioService.validarYGuardar(duenioInput)
	}

	def agregarGustos(Long heladeriaId, Set<Gusto> gustos, DataFetchingEnvironment enviroment) {
		return heladeriaService.agregarGustos(heladeriaId, gustos, entityGraph(enviroment.selectionSet, #["gustos"]))
	}

	def eliminarGustos(Long heladeriaId, Set<Gusto> gustos, DataFetchingEnvironment enviroment) {
		return heladeriaService.eliminarGustos(heladeriaId, gustos, entityGraph(enviroment.selectionSet, #["gustos"]))

	}
}
