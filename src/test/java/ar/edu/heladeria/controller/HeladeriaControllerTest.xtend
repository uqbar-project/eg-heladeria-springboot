package ar.edu.heladeria.controller

import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
import org.springframework.http.MediaType
import ar.edu.heladeria.service.HeladeriaService
import ar.edu.heladeria.domain.Heladeria
import ar.edu.heladeria.controller.TestHelpers
import java.util.Collections
import ar.edu.heladeria.service.DuenioService
import static org.junit.jupiter.api.Assertions.assertEquals

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de heladerias")
class HeladeriaControllerTest {

	@Autowired
	MockMvc mockMvc
	@Autowired
	HeladeriaService heladeriaService
	@Autowired
	DuenioService duenioService

	@Test
	@DisplayName("buscar sin parámetros trae todas las heladerías")
	def void todasLasHeladerias() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/buscar"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(3))
	}

	@Test
	@DisplayName("se puede buscar heladerías por nombre")
	def void buscarHeladeria() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/buscar/{nombre}", "Monte"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.[0].nombre").value("Monte Olivia"))
	}
	
	@Test
	@DisplayName("Si al buscar heladerías el criterio no matchea, devuelve lista vacía")
	def void buscarHeladeriasSinMatch() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/buscar/{nombre}", "criterioinexistente"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(0))
	}

	@Test
	@DisplayName("se puede obtener una heladería por el id")
	def void buscarHeladeriaPorId() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/id/{id}", "1"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.id").value("1"))
		.andExpect(jsonPath("$.nombre").value("Tucán"))
	}

	@Test
	@DisplayName("al buscar una heladería por id inexistente devuelve 404")
	def void buscarHeladeriaPorIdInexistente() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/id/{id}", "999"))
		.andExpect(status.notFound)
	}

	@Test
	@DisplayName("al buscar una heladería por id incorrecto devuelve 400")
	def void buscarHeladeriaPorIdIncorrecto() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/id/{id}", "invalido"))
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("se pueden listar a todos los dueños")
	def void todosLosDuenios() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/duenios"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.length()").value(3))
	}
	
	@Test
	@DisplayName("se puede crear un nuevo dueño con un payload válido")
	def void crearDuenio() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/duenios")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombreCompleto": "Un nuevo duenio"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.nombreCompleto").value('Un nuevo duenio'))
		
		// tearDown
		assertEquals(duenioService.findAll.length, 4)
		duenioService.delete("Un nuevo duenio")
		assertEquals(duenioService.findAll.length, 3)
	}
	
	@Test
	@DisplayName("Intentar crear un dueño con nombre vacío, devuelve 400")
	def void crearDuenioNombreVacioError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/duenios")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombreCompleto": ""}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Intentar crear un dueño con payload invalido, devuelve 400")
	def void crearDuenioInvalidoError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/duenios")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("se puede actualizar una heladería por id con un payload válido")
	def void actualizarHeladeria() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.patch("/heladerias/{heladeriaId}/", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "nuevoNombre"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.nombre").value('nuevoNombre'))
		
		// tearDown
		heladeriaService.actualizar(1L, TestHelpers.fromJson('{"nombre": "Tucán"}', Heladeria))
	}
	
	@Test
	@DisplayName("Intentar actualizar una heladería con nombre vacío, devuelve 400")
	def void actualizarHeladeriaNombreVacioError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.patch("/heladerias/{heladeriaId}/", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": ""}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("intentar actualizar una heladería con payload inválido, devuelve 400")
	def void actualizarHeladeriaCategoriaInvalidaError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.patch("/heladerias/{heladeriaId}/", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"tipoHeladeria": "BUENISIMA"}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("se pueden agregar gustos a una heladería")
	def void agregarGustos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/heladerias/{heladeriaId}/gustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"unNuevoGusto": 10}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.gustos.unNuevoGusto").value(10))
		
		// tearDown
		heladeriaService.eliminarGustos(1L, Collections.singletonMap("unNuevoGusto", 10))
	}
	
	@Test
	@DisplayName("Intentar agregar un gusto con más de 10 de dificultad, devuelve 400")
	def void agregarGustosFueraDeLimiteError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/heladerias/{heladeriaId}/gustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"gustoDemasiadoDificil": 15}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Intentar agregar un gusto sin nombre, devuelve 400")
	def void agregarGustosSinNombreError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/heladerias/{heladeriaId}/gustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"": 5}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("se pueden eliminar gustos a una heladería")
	def void eliminarGustos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.delete("/heladerias/{heladeriaId}/gustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"frutilla": 3}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.gustos.frutilla").doesNotExist)
		
		// tearDown
		heladeriaService.agregarGustos(1L, Collections.singletonMap("frutilla", 3))
	}
	
	@Test
	@DisplayName("Intentar eliminar gustos inexistentes de una heladería, devuelve 400")
	def void eliminarGustosInexistentesError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.delete("/heladerias/{heladeriaId}/gustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"gustoInexistente": 3}')
		)
		.andExpect(status.badRequest)
	}
	
	@Test
	@DisplayName("Intentar eliminar el último gusto de una heladería, devuelve 400")
	def void eliminarUltimoGustoError() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.delete("/heladerias/{heladeriaId}/gustos", "3")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"crema americana": 2}')
		)
		.andExpect(status.badRequest)
	}
}
