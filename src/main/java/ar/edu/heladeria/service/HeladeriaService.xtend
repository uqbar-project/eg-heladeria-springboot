package ar.edu.heladeria.service

import org.springframework.stereotype.Service
import ar.edu.heladeria.repos.RepoHeladeria
import org.springframework.beans.factory.annotation.Autowired

@Service
class HeladeriaService {

	@Autowired
	RepoHeladeria repoHeladeria

	def findAll() {
		repoHeladeria.findAll().toList
	}

}
