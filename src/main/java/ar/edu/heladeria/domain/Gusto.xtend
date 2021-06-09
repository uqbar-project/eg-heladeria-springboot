package ar.edu.heladeria.domain

import ar.edu.heladeria.exceptions.UserException
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import lombok.EqualsAndHashCode
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
@EqualsAndHashCode(of=#["id"])
class Gusto {

	@Id
	@GeneratedValue
	Long id

	@Column(length=150)
	String nombre

	Integer dificultad

	new() {
	}

	new(String nombre, Integer dificultad) {
		this.nombre = nombre
		this.dificultad = dificultad
	}

	def validar() {
		if (nombre.trim.empty) {
			throw new UserException("El gusto no puede estar vacío")
		}
		if (dificultad < 1 || dificultad > 10) {
			throw new UserException("La dificultad debe ser un valor entre 1 y 10 ")
		}
	}

}
