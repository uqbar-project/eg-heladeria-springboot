package ar.edu.heladeria.resolver

import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphUtils
import graphql.schema.DataFetchingFieldSelectionSet
import java.util.List

class ResolverHelpers {

	def static EntityGraph entityGraph(DataFetchingFieldSelectionSet selectionSet) {
		entityGraph(selectionSet, #[])
	}
	
	def static EntityGraph entityGraph(DataFetchingFieldSelectionSet selectionSet, List<String> atributosExtra) {
		println(selectionSet.fields.map[qualifiedName].toSet)
		val attributePaths = selectionSet.fields.map[selectedField|selectedField.qualifiedName.replaceAll("/", ".")].
			toSet
		EntityGraphUtils.fromAttributePaths(attributePaths => [addAll(atributosExtra)])
	}
}
