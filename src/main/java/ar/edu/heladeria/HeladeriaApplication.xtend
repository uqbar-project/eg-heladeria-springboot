package ar.edu.heladeria

import com.cosium.spring.data.jpa.entity.graph.repository.support.EntityGraphJpaRepositoryFactoryBean
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.data.jpa.repository.config.EnableJpaRepositories

@SpringBootApplication
@EnableJpaRepositories(repositoryFactoryBeanClass=EntityGraphJpaRepositoryFactoryBean)
class HeladeriaApplication {
	def static void main(String[] args) {
		SpringApplication.run(HeladeriaApplication, args)
	}
}
