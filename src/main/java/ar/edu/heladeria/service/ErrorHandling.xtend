package ar.edu.heladeria.service

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.server.ResponseStatusException
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler

@ControllerAdvice
class ErrorHandling extends ResponseEntityExceptionHandler {
	@ExceptionHandler(UserException)
	def devolver400(UserException error) {
		throw new ResponseStatusException(HttpStatus.BAD_REQUEST, error.message)
	}

	@ExceptionHandler(NotFoundException)
	def devolver404(NotFoundException error) {
		throw new ResponseStatusException(HttpStatus.NOT_FOUND, error.message)
	}

}

@ResponseStatus(NOT_FOUND)
class NotFoundException extends RuntimeException {

	new(String message) {
		super(message)
	}

}

@ResponseStatus(BAD_REQUEST)
class UserException extends RuntimeException {

	new(String message) {
		super(message)
	}
}
