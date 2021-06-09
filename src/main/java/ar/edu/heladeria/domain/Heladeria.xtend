package ar.edu.heladeria.domain

import ar.edu.heladeria.exceptions.UserException
import ar.edu.heladeria.input.ActualizarHeladeriaInput
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
class Heladeria {

	@Id
	@GeneratedValue
	Long id

	@Column(length=150)
	String nombre

	@Transient
	Heladeria heladeria

	@Enumerated(EnumType.ORDINAL) // o EnumType.STRING
	TipoHeladeria tipoHeladeria

	@ManyToOne(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Duenio duenio

	@JoinColumn(name="heladeria_id")
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Set<Gusto> gustos

	new() {
		gustos = newHashSet
	}

	def void validar() {
		if (nombre === null || nombre.trim.empty) {
			throw new UserException("Debe cargar el nombre")
		}
		if (duenio === null) {
			throw new UserException("Debe elegir el dueño")
		}
		validarGustos(gustos)
	}

	def agregarGustos(Set<Gusto> gustosNuevos) {
		validarGustos(gustosNuevos)
		gustos.addAll(gustosNuevos)
	}

	def validarGustos(Set<Gusto> gustos) {
		if (gustos.isEmpty) {
			throw new UserException("Debe seleccionar al menos un gusto")
		}
		gustos.forEach[validar]
	}

	def eliminarGusto(Gusto gusto) {
		if (!gustos.contains(gusto)) {
			throw new UserException("El gusto a eliminar no existe")
		}
		gustos.remove(gusto)
	}

	def merge(ActualizarHeladeriaInput heladeriaInput) {
		nombre = heladeriaInput.nombre ?: nombre
		tipoHeladeria = heladeriaInput.tipoHeladeria ?: tipoHeladeria
		duenio = heladeriaInput.duenio ?: duenio
	}

}

enum TipoHeladeria {
	ECONOMICA,
	ARTESANAL,
	INDUSTRIAL
}
