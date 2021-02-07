package ar.edu.heladeria.appModel

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.domain.TipoHeladeria
import ar.edu.heladeria.repos.RepoDuenios
import ar.edu.heladeria.repos.RepoHeladeria
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.utils.ObservableUtils

@Observable
@Accessors
class EditarHeladeria {
	
	RepoHeladeria repoHeladeria = RepoHeladeria.instance
	RepoDuenios repoDuenios = RepoDuenios.instance
	Heladeria heladeria
	String duenioNuevo
	Integer dificultad
	String gustoNuevo
	String gustoSeleccionado
	
	new(Heladeria heladeria) {
		this.heladeria = repoHeladeria.get(heladeria)
	}
	
//	def void agregarGusto() {
//		heladeria.agregarGusto(gustoNuevo, dificultad)
//		actualizar
//		gustoNuevo = ""
//		dificultad = null
//		ObservableUtils.firePropertyChanged(this.heladeria, "gustos", heladeria.gustos)
//	}
	
	@Dependencies("gustoNuevo", "dificultad")
	def boolean getPuedeAgregarGusto() {
		gustoNuevo !== null && !gustoNuevo.equals("") && dificultad !== null && dificultad.between(1, 10)
	}
	
	def between(Integer value, int min, int max) {
		value >= min && value <= max
	}

	def void agregarDuenio() {
		heladeria.duenio = new Duenio => [
			nombreCompleto = duenioNuevo
		]
		actualizar
		duenioNuevo = ""
		ObservableUtils.firePropertyChanged(this, "duenios", duenios)
		ObservableUtils.firePropertyChanged(this.heladeria, "duenio", heladeria.duenio)
	}
	
	@Dependencies("duenioNuevo")
	def boolean getPuedeAgregarDuenio() {
		duenioNuevo !== null && !duenioNuevo.equals("")
	}

	@Dependencies("gustoSeleccionado")
	def boolean getPuedeEliminarGusto() {
		gustoSeleccionado !== null && !gustoSeleccionado.equals("")
	}
	
	def void eliminarGusto() {
		val gusto = gustoSeleccionado.split(" -> ").head
//		heladeria.eliminarGusto(gusto)
		repoHeladeria.createOrUpdate(heladeria)
	}
	
	def void actualizar() {
		repoHeladeria.createOrUpdate(heladeria)
	}

	def getDuenios() {
		repoDuenios.allInstances
	}
	
	def getTiposHeladeria() {
		#{TipoHeladeria.ARTESANAL, TipoHeladeria.ECONOMICA, TipoHeladeria.INDUSTRIAL}
	}
}
