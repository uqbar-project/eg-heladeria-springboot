package ar.edu.heladeria.graphql

import ar.edu.heladeria.service.DuenioService
import ar.edu.heladeria.service.HeladeriaService
import com.google.common.base.Charsets
import com.google.common.io.Resources
import graphql.GraphQL
import graphql.schema.GraphQLSchema
import graphql.schema.idl.RuntimeWiring
import graphql.schema.idl.SchemaGenerator
import graphql.schema.idl.SchemaParser
import graphql.schema.idl.TypeDefinitionRegistry
import java.net.URL
import javax.annotation.PostConstruct
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component

import static graphql.schema.idl.TypeRuntimeWiring.newTypeWiring

@SuppressWarnings("Duplicates")
@Component
class GraphQLProvider {

	@Autowired
	HeladeriaService heladeriaService
	@Autowired
	DuenioService duenioService

	GraphQL graphQL

	@Bean
	def GraphQL graphQL() {
		return graphQL
	}

	@PostConstruct
	def init() {
		val URL url = Resources.getResource("schema.graphqls")
		val String sdl = Resources.toString(url, Charsets.UTF_8)
		val GraphQLSchema graphQLSchema = buildSchema(sdl)
		this.graphQL = GraphQL.newGraphQL(graphQLSchema).build()
	}

	def GraphQLSchema buildSchema(String sdl) {
		val TypeDefinitionRegistry typeRegistry = new SchemaParser().parse(sdl)
		val RuntimeWiring runtimeWiring = buildWiring
		val SchemaGenerator schemaGenerator = new SchemaGenerator()
		return schemaGenerator.makeExecutableSchema(typeRegistry, runtimeWiring)
	}

	def RuntimeWiring buildWiring() {
		return RuntimeWiring.newRuntimeWiring()
		.type(newTypeWiring("Query")
			.dataFetcher("todasLasHeladerias", heladeriaService.findAll)
			.dataFetcher("buscarHeladerias", heladeriaService.findByNombre)
			.dataFetcher("heladeria",heladeriaService.findById)
			.dataFetcher("duenios",duenioService.findAll))
		.type(newTypeWiring("Mutation")
			.dataFetcher("actualizarHeladeria", heladeriaService.actualizar)
			.dataFetcher("agregarGustos", heladeriaService.agregarGustos)
			.dataFetcher("eliminarGustos", heladeriaService.eliminarGustos)
			.dataFetcher("crearDuenio", duenioService.validarYGuardar))
			.build()
	}
}
