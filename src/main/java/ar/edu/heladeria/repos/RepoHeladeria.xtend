package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import java.util.List

@Repository
interface RepoHeladeria extends CrudRepository<Heladeria, Long> {

	def Heladeria findByNombre(String nombre)

	def List<Heladeria> findByNombreContaining(String nombre)

}
