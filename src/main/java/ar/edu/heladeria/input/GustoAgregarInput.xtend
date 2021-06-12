package ar.edu.heladeria.input

import ar.edu.heladeria.domain.Gusto
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class GustoAgregarInput {

	String nombre

	Integer dificultad

	def Gusto toGusto() {
		new Gusto(nombre, dificultad)
	}

}

@Accessors
class GustoEliminarInput {

	Long id

	def Gusto toGusto() {
		new Gusto => [it.id = this.id]
	}
}
