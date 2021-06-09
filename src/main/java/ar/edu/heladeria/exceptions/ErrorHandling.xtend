package ar.edu.heladeria.exceptions

import graphql.kickstart.spring.error.ThrowableGraphQLError
import org.springframework.stereotype.Component
import org.springframework.web.bind.annotation.ExceptionHandler

@Component
class GraphqlExceptionHandler {

	@ExceptionHandler(NotFoundException, UserException)
	def ThrowableGraphQLError handle(RuntimeException e) {
		return new ThrowableGraphQLError(e)
	}
	
	@ExceptionHandler(RuntimeException)
	def ThrowableGraphQLError handleRuntimeException(RuntimeException e) {
		return new ThrowableGraphQLError(e, "Internal Server Error")
	}
}

class NotFoundException extends RuntimeException {

	new(String message) {
		super(message)
	}
}

class UserException extends RuntimeException {

	new(String message) {
		super(message)
	}
}
