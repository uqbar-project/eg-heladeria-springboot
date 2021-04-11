FROM maven:3.6.3-openjdk-11

WORKDIR /usr/src

COPY [".", "/usr/src/"]

RUN mvn clean package

CMD mvn spring-boot:run