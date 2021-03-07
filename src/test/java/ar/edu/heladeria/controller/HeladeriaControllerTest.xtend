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
import java.util.Map
import java.util.Collections

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de heladerias")
class HeladeriaControllerTest {

	@Autowired
	MockMvc mockMvc
	@Autowired
	HeladeriaService heladeriaService

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
	@DisplayName("se puede buscar una heladería por el nombre")
	def void buscarHeladeria() {
		mockMvc
		.perform(MockMvcRequestBuilders.get("/heladerias/buscar/{nombre}", "Monte"))
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.[0].nombre").value("Monte Olivia"))
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
	@DisplayName("se puede actualizar una heladería por id con un payload válido")
	def void actualizarHeladeria() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.patch("/heladerias/{heladeriaId}/actualizar", "1")
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
	@DisplayName("se pueden agregar gustos a una heladería")
	def void agregarGustos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/heladerias/{heladeriaId}/agregarGustos", "1")
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
	@DisplayName("se pueden eliminar gustos a una heladería")
	def void eliminarGustos() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.delete("/heladerias/{heladeriaId}/eliminarGustos", "1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"frutilla": 3}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.gustos.length()").value(3))
		
		// tearDown
		heladeriaService.agregarGustos(1L, Collections.singletonMap("frutilla", 3))
	}
}
