package ar.edu.heladeria

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Gusto
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.domain.TipoHeladeria
import ar.edu.heladeria.repos.RepoHeladeria
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class HeladeriaBootstrap implements InitializingBean {

	Heladeria tucan
	Heladeria monteOlivia
	Heladeria frigor
	@Autowired
	RepoHeladeria repoHeladeria

	def getTucan() {
		tucan
	}

	def void initHeladerias() {
		tucan = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Carlos Martinelli"
			]
			nombre = "Tucán"
			gustos = #[new Gusto("frutilla", 3), new Gusto("maracuya", 2), new Gusto("dulce de leche", 4),
				new Gusto("pistacchio", 6)].toSet
			tipoHeladeria = TipoHeladeria.ECONOMICA
		]

		monteOlivia = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Olivia Heladette"
			]
			nombre = "Monte Olivia"
			gustos = #[new Gusto("chocolate amargo", 8), new Gusto("dulce de leche", 3),
				new Gusto("mousse de limón", 5), new Gusto("crema tramontana", 9), new Gusto("vainilla", 1)].toSet
			tipoHeladeria = TipoHeladeria.ARTESANAL
		]

		frigor = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Manuela Fritzler y Carlos Gorriti"
			]
			nombre = "Frigor"
			gustos = #[new Gusto("crema americana", 2)].toSet
			tipoHeladeria = TipoHeladeria.INDUSTRIAL
		]

		crearOActualizarHeladeria(tucan)
		crearOActualizarHeladeria(monteOlivia)
		crearOActualizarHeladeria(frigor)
	}

	def void crearOActualizarHeladeria(Heladeria heladeria) {
		repoHeladeria.save(heladeria)
		println("Heladería " + heladeria.nombre + " creada")
	}

	override afterPropertiesSet() throws Exception {
		if (repoHeladeria.count < 3) {
			initHeladerias
		}
	}

}
