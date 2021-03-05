package ar.edu.heladeria.domain

import ar.edu.heladeria.service.UserException
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
import javax.persistence.MapKeyColumn
import javax.persistence.NamedAttributeNode
import javax.persistence.NamedEntityGraph
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity
@NamedEntityGraph(name="Heladeria.default", attributeNodes=#[@NamedAttributeNode("gustos"),
	@NamedAttributeNode("duenio")])
class Heladeria {

	@Id
	@GeneratedValue
	Long id

	@Column(length=150)
	String nombre

	@Enumerated(EnumType.ORDINAL) // o EnumType.STRING
	TipoHeladeria tipoHeladeria

	@ManyToOne(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Duenio duenio

	@ElementCollection
	@CollectionTable(name="Heladeria_Gustos", joinColumns=@JoinColumn(name="heladeria_id"))
	@Column(name="dificultad")
	@MapKeyColumn(name="gusto")
	Map<String, Integer> gustos

	// el mapa se compone de gusto, dificultad
	new() {
		gustos = newHashMap
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

	override toString() {
		nombre
	}

	def agregarGusto(String gusto, int dificultad) {
		validarGusto(gusto, dificultad)
		gustos.put(gusto, dificultad)
	}

	def agregarGustos(Map<String, Integer> gustosNuevos) {
		validarGustos(gustosNuevos)
		gustos.putAll(gustosNuevos)
	}

	def validarGusto(String gusto, int dificultad) {
		if (gusto.trim.empty) {
			throw new UserException("El gusto no puede estar vacío")
		}
		if (dificultad < 1 || dificultad > 10) {
			throw new UserException("La dificultad debe ser un valor entre 1 y 10 ")
		}
	}

	def validarGustos(Map<String, Integer> gustos) {
		if (gustos.isEmpty) {
			throw new UserException("Debe seleccionar al menos un gusto")
		}
		gustos.forEach[gusto, dificultad|validarGusto(gusto, dificultad)]
	}

	def gustosQueOfrece() {
		gustos.keySet.map[gusto|gusto + " -> " + gustos.get(gusto)].toList
	}

	def eliminarGusto(String gusto) {
		if (!gustos.containsKey(gusto)) {
			throw new UserException("El gusto a eliminar '" + gusto + "' no existe")
		}
		gustos.remove(gusto)
	}

	def merge(Heladeria otraHeladeria) {
		nombre = otraHeladeria.nombre !== null ? otraHeladeria.nombre : nombre
		tipoHeladeria = otraHeladeria.tipoHeladeria !== null ? otraHeladeria.tipoHeladeria : tipoHeladeria
		duenio = otraHeladeria.duenio !== null ? otraHeladeria.duenio : duenio
	}

}

enum TipoHeladeria {
	ECONOMICA,
	ARTESANAL,
	INDUSTRIAL
}
