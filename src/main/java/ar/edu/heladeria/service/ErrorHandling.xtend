package ar.edu.heladeria.service

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler
import org.uqbar.commons.model.exceptions.UserException

@ControllerAdvice
class ErrorHandling extends ResponseEntityExceptionHandler {

	@ExceptionHandler(UserException)
	def devolver400(UserException error) {
		ResponseEntity.badRequest.body(error.message)
	}

}
