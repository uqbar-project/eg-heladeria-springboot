package ar.edu.heladeria.appModel

import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.repos.RepoHeladeria
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
class ListaHeladerias {

	List<Heladeria> heladerias
	Heladeria heladeriaSeleccionada	
	String nombreHeladeria
	
	def void buscar() {
		heladerias = RepoHeladeria.instance.searchByExample(new Heladeria => [
			nombre = nombreHeladeria
		])
	}
	
	@Dependencies("heladeriaSeleccionada")
	def boolean getPuedeEditarHeladeria() {
		heladeriaSeleccionada !== null
	}
	
}
