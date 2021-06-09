package ar.edu.heladeria.input

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.TipoHeladeria
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ActualizarHeladeriaInput {

	Long id

	String nombre

	Duenio duenio

	TipoHeladeria tipoHeladeria

}
