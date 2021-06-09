package ar.edu.heladeria.resolver

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import graphql.kickstart.tools.GraphQLResolver
import org.springframework.stereotype.Component

@Component
class DuenioResolver implements GraphQLResolver<Heladeria> {

	def Duenio duenio(Heladeria heladeria) {
		heladeria.duenio.email = "xxxx" + heladeria.duenio.nombreCompleto.substring(4)
		heladeria.duenio
	}

}
