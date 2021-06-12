package ar.edu.heladeria.input

import ar.edu.heladeria.domain.Gusto
import javax.annotation.Nonnull
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class GustoAgregar {
	@Nonnull
	String nombre
	@Nonnull
	Integer dificultad

	def Gusto toGusto() {
		new Gusto(nombre, dificultad)
	}

}

@Accessors
class GustoEliminar {
	@Nonnull
	Long id

	def Gusto toGusto() {
		new Gusto => [it.id = this.id]
	}
}
