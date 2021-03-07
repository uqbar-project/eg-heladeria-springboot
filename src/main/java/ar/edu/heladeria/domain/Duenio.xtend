package ar.edu.heladeria.domain

import ar.edu.heladeria.service.UserException
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
class Duenio {

	@Id
	@GeneratedValue
	Long id

	@Column(length=150)
	String nombreCompleto

	def validar() {
		if (nombreCompleto === null || nombreCompleto.trim.empty) {
			throw new UserException("El nombre para el duenio no puede ser vacío")
		}
	}

}
