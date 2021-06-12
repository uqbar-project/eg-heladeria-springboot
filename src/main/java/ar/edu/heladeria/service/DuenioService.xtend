package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.repos.RepoDuenios
import io.leangen.graphql.annotations.GraphQLMutation
import io.leangen.graphql.annotations.GraphQLQuery
import io.leangen.graphql.spqr.spring.annotations.GraphQLApi
import javax.annotation.Nonnull
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@GraphQLApi
@Service
class DuenioService {

	@Autowired
	RepoDuenios repoDuenios

	@GraphQLQuery(name="duenios", description="Obtener todos los dueños")
	@Nonnull
	def findAll() {
		repoDuenios.findAll().toList
	}

	@GraphQLMutation(name="crearDuenio", description="Crear un nuevo dueño")
	@Nonnull
	def validarYGuardar(@Nonnull Duenio duenio) {
		duenio.validar
		repoDuenios.save(duenio)
	}

	def findById(Long duenioId) {
		repoDuenios.findById(duenioId).orElseThrow([
			throw new NotFoundException("No se encontró el duenio indicado: " + duenioId.toString)
		])
	}

}
