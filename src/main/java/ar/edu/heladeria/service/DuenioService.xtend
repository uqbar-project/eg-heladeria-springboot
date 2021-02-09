package ar.edu.heladeria.service

import ar.edu.heladeria.repos.RepoDuenios
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class DuenioService {

	@Autowired
	RepoDuenios repoDuenios

	def findAll() {
		repoDuenios.findAll().toList
	}

}
