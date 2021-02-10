package ar.edu.heladeria.service

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.repos.RepoHeladeria
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.uqbar.commons.model.exceptions.UserException
import ar.edu.heladeria.repos.RepoDuenios

@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria
	@Autowired
	RepoDuenios repoDuenios

	def findAll() {
		repoHeladeria.findAll().toList
	}

	def findByNombre(String nombre) {
		repoHeladeria.findByNombreContaining(nombre)
	}

	def agregarDuenio(Long heladeriaId, Duenio duenio) {
		val Heladeria heladeria = repoHeladeria.findById(heladeriaId).orElseThrow([|
			throw new UserException("No se encontró la heladería indicada: " + heladeriaId.toString)
		]);

		val Duenio duenioFound = repoDuenios.findById(duenio.id).orElseThrow([|
			throw new UserException("No se encontró el duenio indicada: " + duenio.id.toString)
		]);

		heladeria.duenio = duenioFound
		repoHeladeria.save(heladeria)
	}

}
