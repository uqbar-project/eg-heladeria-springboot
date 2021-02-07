package ar.edu.heladeria.repos

import ar.edu.heladeria.domain.Heladeria
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.JoinType
import javax.persistence.criteria.Root

class RepoHeladeria extends AbstractRepoSQL<Heladeria> {

	static RepoHeladeria instance
	
	static def getInstance() {
		if (instance === null) {
			instance = new RepoHeladeria()
		}
		return instance
	}
		
	override getEntityType() {
		Heladeria
	}

	override generateWhere(CriteriaBuilder criteria, CriteriaQuery<Heladeria> query, Root<Heladeria> camposHeladeria, Heladeria heladeria) {
		if (heladeria.nombre !== null) {
			query.where(criteria.like(camposHeladeria.get("nombre"), "%" + heladeria.nombre + "%"))
		}
	}
	
	def Heladeria get(Long id) {
		val criteria = entityManager.criteriaBuilder
		val query = criteria.createQuery(Heladeria)
		val Root<Heladeria> from = query.from(Heladeria)
		from.fetch("gustos", JoinType.INNER)
		query
			.select(from)
			.where(criteria.equal(from.get("id"), id))
		return entityManager.createQuery(query).singleResult
	}
	
	def Heladeria get(Heladeria heladeria) {
		return get(heladeria.id)
	}

}
