package ar.edu.heladeria.serializer

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.domain.TipoHeladeria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class HeladeriaDTO {

	Long id

	String nombre

	TipoHeladeria tipoHeladeria

	Duenio duenio

	private new() {
	}

	def static fromHeladeria(Heladeria heladeria) {
		new HeladeriaDTO => [
			id = heladeria.id
			nombre = heladeria.nombre
			tipoHeladeria = heladeria.tipoHeladeria
			duenio = heladeria.duenio
		]
	}

}
