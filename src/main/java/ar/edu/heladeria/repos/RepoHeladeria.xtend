package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface RepoHeladeria extends CrudRepository<Heladeria, Long> {

	def Heladeria findByNombre(String nombre)

	@EntityGraph(attributePaths=#[
		"gustos",
		"duenio"
	])
	override Optional<Heladeria> findById(Long id) {
	}
}
