package ar.edu.heladeria.input

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.TipoHeladeria
import javax.annotation.Nonnull
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class HeladeriaActualizar {

	@Nonnull
	Long id

	String nombre

	Duenio duenio

	TipoHeladeria tipoHeladeria

}
