FROM maven:3.6.3-openjdk-11

WORKDIR /usr/src

COPY ["pom.xml", "/usr/src/"]

RUN mvn dependency:go-offline

COPY [".", "/usr/src/"]

CMD mvn spring-boot:run