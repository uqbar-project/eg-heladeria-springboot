package ar.edu.heladeria

import ar.edu.heladeria.domain.Duenio
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.domain.TipoHeladeria
import ar.edu.heladeria.repos.RepoHeladeria

class HeladeriaBootstrap {

	Heladeria tucan
	Heladeria monteOlivia
	Heladeria frigor

	def void initHeladerias() {
		tucan = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Carlos Martinelli"
			]
			nombre = "Tucán"
			gustos = #{"frutilla" -> 3, "maracuya" -> 2, "dulce de leche" -> 4, "pistacchio" -> 6}
			tipoHeladeria = TipoHeladeria.ECONOMICA
		]

		monteOlivia = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Olivia Heladette"
			]
			nombre = "Monte Olivia"
			gustos = #{"chocolate amargo" -> 8, "dulce de leche" -> 3, "mousse de limón" -> 5, "crema tramontana" -> 9,
				"vainilla" -> 1}
			tipoHeladeria = TipoHeladeria.ARTESANAL
		]

		frigor = new Heladeria => [
			duenio = new Duenio => [
				nombreCompleto = "Manuela Fritzler y Carlos Gorriti"
			]
			nombre = "Frigor"
			gustos = #{"crema americana" -> 2}
			tipoHeladeria = TipoHeladeria.INDUSTRIAL
		]

		crearOActualizarHeladeria(tucan)
		crearOActualizarHeladeria(monteOlivia)
		crearOActualizarHeladeria(frigor)
	}

	def void crearOActualizarHeladeria(Heladeria heladeria) {
		val repoHeladeria = RepoHeladeria.instance
		val listaHeladerias = repoHeladeria.searchByExample(heladeria)
		if (listaHeladerias.isEmpty) {
			repoHeladeria.createOrUpdate(heladeria)
			println("Heladería " + heladeria.nombre + " creada")
		}
	}

}
