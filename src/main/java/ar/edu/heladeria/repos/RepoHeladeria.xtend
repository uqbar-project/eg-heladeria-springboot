package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import com.cosium.spring.data.jpa.entity.graph.repository.EntityGraphJpaRepository
import java.util.List
import org.springframework.stereotype.Repository
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph

@Repository
interface RepoHeladeria extends EntityGraphJpaRepository<Heladeria, Long> {

	def List<Heladeria> findByNombreContaining(String nombre, EntityGraph entityGraph)

}
