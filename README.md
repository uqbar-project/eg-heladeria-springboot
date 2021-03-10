# Ejemplo Heladeria Springboot

[![CI](https://github.com/uqbar-project/eg-heladeria-springboot/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/uqbar-project/eg-heladeria-springboot/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/github/uqbar-project/eg-heladeria-springboot/badge.svg?branch=main&kill_cache=1)](https://coveralls.io/github/uqbar-project/eg-heladeria-springboot?branch=main)

Este ejemplo está implementado con Xtend y Springboot, se recomienda acompañarlo con el frontend desarrollado en svelte:
https://github.com/uqbar-project/eg-heladeria-svelte

Además necesitarás tener levantada una base de datos MySQL con un esquema llamado `heladeria`

```
drop schema if exists heladeria;
create schema if not exists heladeria;
```

Encontrarás:
* un modelo de datos compuesto por heladerías, que definen un mapa de gustos (strings) con dificultades de fabricación (integers)
* las heladerías pueden ser artesanales, económicas o industriales, implementadas con un enum
* hay además una relación many-to-one con su dueño


## Diagrama de arquitectura

![image](https://user-images.githubusercontent.com/4999277/110565242-ebd3c300-812c-11eb-8509-a70e81c05e18.png)
