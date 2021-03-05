package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface RepoHeladeria extends CrudRepository<Heladeria, Long> {

	final String GRAFO_DEFAULT = "Heladeria.default"

	@EntityGraph(GRAFO_DEFAULT)
	override findAll()

	@EntityGraph(GRAFO_DEFAULT)
	override findById(Long id)

	@EntityGraph(GRAFO_DEFAULT)
	def Heladeria findByNombre(String nombre)

	@EntityGraph(GRAFO_DEFAULT)
	def List<Heladeria> findByNombreContaining(String nombre)

}
