package ar.edu.heladeria.resolver

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Gusto
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.input.ActualizarHeladeriaInput
import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import graphql.kickstart.tools.GraphQLMutationResolver
import java.util.Set
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

@Component
class HeladeriaMutationResolver implements GraphQLMutationResolver {

	@Autowired
	HeladeriaService heladeriaService

	@Autowired
	DuenioService duenioService

	def Heladeria actualizarHeladeria(ActualizarHeladeriaInput heladeriaInput) {
		return heladeriaService.actualizar(heladeriaInput)
	}

	def Duenio crearDuenio(Duenio duenioInput) {
		return duenioService.validarYGuardar(duenioInput)
	}

	def agregarGustos(Long heladeriaId, Set<Gusto> gustos) {
		return heladeriaService.agregarGustos(heladeriaId, gustos)
	}

	def eliminarGustos(Long heladeriaId, Set<Gusto> gustos) {
		return heladeriaService.eliminarGustos(heladeriaId, gustos)

	}
}
