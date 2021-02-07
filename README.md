# Primer ejemplo Servicio REST: Saludo con Springboot

[![Build Status](https://travis-ci.com/algo3-unsam/tp-recetas-2020-gr-XX.svg?branch=master)](https://travis-ci.com/algo3-unsam/tp-recetas-2020-gr-XX)

## El proyecto

Antes que nada, la idea de este proyecto es que te sirva como base para poder desarrollar el backend en la materia [Algoritmos 3](https://algo3.uqbar-project.org/). Por eso está basado en _Maven_, y el archivo `pom.xml` tiene dependencias a

- Spring Boot
- JUnit 5
- la última versión actual de Xtend
- además de estar basado en la JDK 11

### Pasos para adaptar tu proyecto de Algo2 a Algo3

El proceso más simple para que puedan reutilizar el proyecto de Algo2 en Algo3 es:

- generar una copia de todo el directorio que contiene este proyecto
- eliminar la carpeta `.git` que está oculta
- renombrar en el `pom.xml` los valores para `artifactId`, `name` y `description` para que tengan el nombre de tu proyecto (renombrando gr-XX por el grupo correspondiente)

```xml
	<groupId>org.uqbar</groupId>
	<artifactId>---- nombre del proyecto ----</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>war</packaging>
	<name>---- nombre del proyecto ----</name>
	<description>---- acá va la description ----</description>
```

- copian del proyecto de Algo2 las carpetas `src/main/java` y `src/test/java` y la ubican en el mismo lugar en el proyecto de Algo3

El proyecto tiene un main, en la clase `RecetasApplication`, que levantará el servidor web en el puerto 8080. 
