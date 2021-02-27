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

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de heladerias")
class HeladeriaControllerTest {

	@Autowired
	MockMvc mockMvc

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
		.andExpect(jsonPath("$.[0].nombre").value("Monte Castro"))
	}

	@Test
	@DisplayName("se puede buscar una heladería por el id")
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
		.perform(MockMvcRequestBuilders.get("/heladerias/id/{id}", "hola"))
		.andExpect(status.badRequest)
	}
}
