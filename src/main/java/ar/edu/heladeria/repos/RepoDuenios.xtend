package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Duenio
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Root

class RepoDuenios extends AbstractRepoSQL<Duenio> {
	
	static RepoDuenios instance
	
	static def getInstance() {
		if (instance === null) {
			instance = new RepoDuenios()
		}
		return instance
	}
	
	override getEntityType() {
		Duenio
	}
	
	override generateWhere(CriteriaBuilder criteria, CriteriaQuery<Duenio> query, Root<Duenio> camposDuenio, Duenio duenio) {
		if (duenio.nombreCompleto !== null) {
			query.where(criteria.like(camposDuenio.get("nombre"), "%" + duenio.nombreCompleto + "%"))
		}
	}
	
}