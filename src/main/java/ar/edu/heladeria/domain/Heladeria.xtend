package ar.edu.heladeria.domain

import ar.edu.heladeria.service.UserException
import java.text.Normalizer
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
import org.eclipse.xtend.lib.annotations.Accessors

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

	def agregarGustos(Map<String, Integer> gustosNuevos) {
		validarGustos(gustosNuevos)
		gustosNuevos.entrySet.forEach [ gusto |
			agregarGusto(gusto.key, gusto.value)
		]
	}

	def agregarGusto(String gusto, Integer dificultad) {
		var gustoNormalizado = Normalizer.normalize(gusto.toLowerCase, Normalizer.Form.NFD).replaceAll("\\p{M}", "");
		gustos.put(gustoNormalizado, dificultad)
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

	def eliminarGusto(String gusto) {
		if (!gustos.containsKey(gusto)) {
			throw new UserException("El gusto a eliminar '" + gusto + "' no existe")
		}
		gustos.remove(gusto)
	}

	def merge(Heladeria otraHeladeria) {
		nombre = otraHeladeria.nombre ?: nombre
		tipoHeladeria = otraHeladeria.tipoHeladeria ?: tipoHeladeria
		duenio = otraHeladeria.duenio ?: duenio
	}

}

enum TipoHeladeria {
	ECONOMICA,
	ARTESANAL,
	INDUSTRIAL
}
