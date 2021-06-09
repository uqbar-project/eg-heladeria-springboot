package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.exceptions.NotFoundException
import ar.edu.heladeria.repos.RepoDuenios
import javax.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class DuenioService {

	@Autowired
	RepoDuenios repoDuenios

	def findAll() {
		repoDuenios.findAll().toList
	}

	def validarYGuardar(Duenio duenio) {
		duenio.validar
		repoDuenios.save(duenio)
	}

	def findById(Long duenioId) {
		repoDuenios.findById(duenioId).orElseThrow([
			throw new NotFoundException("No se encontró el duenio indicado: " + duenioId.toString)
		])
	}

	@Transactional
	def delete(String nombreCompleto) {
		repoDuenios.deleteByNombreCompleto(nombreCompleto)
	}

}
