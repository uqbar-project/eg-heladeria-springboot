package ar.edu.heladeria.domain

import java.util.Map
import javax.persistence.CascadeType
import javax.persistence.CollectionTable
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.exceptions.UserException

@Accessors
@Entity
class Heladeria {

	@Id
	@GeneratedValue
	Long id

	@Column(length=150)
	String nombre

	@Enumerated(EnumType.ORDINAL) // o EnumType.STRING
	TipoHeladeria tipoHeladeria

	@ManyToOne(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	Duenio duenio

	@ElementCollection
	@CollectionTable(name="Heladeria_Gustos", joinColumns=@JoinColumn(name="heladeria_id"))
	@Column(name="gustos")
	Map<String, Integer> gustos

	// el mapa se compone de gusto, dificultad
	new() {
		gustos = newHashMap
	}

	def void validar() {
		if (nombre === null || nombre.trim.equals("")) {
			throw new UserException("Debe cargar el nombre")
		}
		if (duenio === null) {
			throw new UserException("Debe elegir el dueño")
		}
		if (gustos.isEmpty) {
			throw new UserException("Debe seleccionar al menos un gusto")
		}
	}

	override toString() {
		nombre
	}

	def agregarGusto(String gusto, int cantidad) {
		gustos.put(gusto, cantidad)
	}

	def gustosQueOfrece() {
		gustos.keySet.map[gusto|gusto + " -> " + gustos.get(gusto)].toList
	}

	def eliminarGusto(String gusto) {
		gustos.remove(gusto)
	}
	

}

enum TipoHeladeria {
	ECONOMICA,
	ARTESANAL,
	INDUSTRIAL
}
