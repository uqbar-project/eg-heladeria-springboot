package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Duenio
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface RepoDuenios extends CrudRepository<Duenio, Long> {

	def Duenio findByNombreCompleto(String nombreCompleto)

	def void deleteByNombreCompleto(String nombreCompleto)
}
