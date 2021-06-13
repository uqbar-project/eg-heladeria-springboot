package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.repos.RepoDuenios
import com.fasterxml.jackson.databind.ObjectMapper
import graphql.schema.DataFetchingEnvironment
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class DuenioService {

	@Autowired
	RepoDuenios repoDuenios

	static final ObjectMapper mapper = new ObjectMapper

	def findAll() {
		[repoDuenios.findAll().toList]
	}

	def validarYGuardar() {
		return [ DataFetchingEnvironment enviroment |
			val Duenio duenio = mapper.convertValue(enviroment.getArgument("duenio"), Duenio)
			duenio.validar
			repoDuenios.save(duenio)
		]
	}

	def findById(Long duenioId) {
		repoDuenios.findById(duenioId).orElseThrow([
			throw new NotFoundException("No se encontró el duenio indicado: " + duenioId.toString)
		])
	}

	def findById() {
		return [ DataFetchingEnvironment enviroment |
			val duenioId = Long.parseLong(enviroment.getArgument("id"))
			findById(duenioId)
		]
	}

}
