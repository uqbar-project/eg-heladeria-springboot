package ar.edu.heladeria.resolver

import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraph
import com.cosium.spring.data.jpa.entity.graph.domain.EntityGraphUtils
import graphql.schema.DataFetchingFieldSelectionSet
import java.util.List

class EntityGraphHelpers {

	def static EntityGraph fromAttributePaths(List<String> attributePaths) {
		EntityGraphUtils.fromAttributePaths(attributePaths.toSet)
	}

	def static EntityGraph fromSelectionSet(DataFetchingFieldSelectionSet selectionSet) {
		println(selectionSet.fields.map[qualifiedName].toSet)
		val attributePaths = selectionSet.fields.map[selectedField|selectedField.qualifiedName.replaceAll("/", ".")]
		fromAttributePaths(attributePaths)
	}
}
