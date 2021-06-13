package ar.edu.heladeria.domain

import ar.edu.heladeria.exceptions.UserException
import ar.edu.heladeria.input.HeladeriaActualizar
import java.util.List
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
	List<Gusto> gustos

	new() {
		gustos = newArrayList
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

	def agregarGustos(List<Gusto> gustosNuevos) {
		validarGustos(gustosNuevos)
		gustos.addAll(gustosNuevos)
	}

	def validarGustos(List<Gusto> gustos) {
		if (gustos.isEmpty) {
			throw new UserException("Debe seleccionar al menos un gusto")
		}
		gustos.forEach[validar]
	}

	def eliminarGusto(Gusto gustoAEliminar) {
		if (!gustos.contains(gustoAEliminar)) {
			throw new UserException("El gusto a eliminar '" + gustoAEliminar.id + "' no existe")
		}
		gustos.remove(gustoAEliminar)
	}

	def merge(HeladeriaActualizar heladeriaInput) {
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
