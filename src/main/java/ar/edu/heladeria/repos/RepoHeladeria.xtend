package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface RepoHeladeria extends CrudRepository<Heladeria, Long> {

	@EntityGraph(attributePaths = #["duenio"])
	override findAll()

	@EntityGraph(attributePaths = #["duenio", "gustos"])
	override findById(Long id)

	@EntityGraph(attributePaths = #["duenio"])
	def List<Heladeria> findByNombreContaining(String nombre)

}
