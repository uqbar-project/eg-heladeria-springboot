package ar.edu.heladeria.service

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler
import org.uqbar.commons.model.exceptions.UserException
import org.springframework.http.HttpStatus

@ControllerAdvice
class ErrorHandling extends ResponseEntityExceptionHandler {

	@ExceptionHandler(UserException)
	def devolver400(UserException error) {
		ResponseEntity.badRequest.body(error.message)
	}
	
	@ExceptionHandler(NotFoundException)
	def devolver404(NotFoundException error) {
		ResponseEntity.status(HttpStatus.NOT_FOUND).body(error.message)
	}

}

class NotFoundException extends UserException {
	
	new(String message) {
		super(message)
	}
	
}
