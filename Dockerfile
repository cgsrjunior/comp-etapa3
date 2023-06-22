# /* Trabalho de Compiladores - Cleiber Rodrigues e Cintia Valente */
# /* Cartões: 00270139 */

FROM debian:testing

RUN apt-get -y update
RUN apt-get -y install build-essential make gcc gdb flex bison valgrind
RUN useradd -s /bin/bash --create-home user
USER user
WORKDIR /user/home

COPY . .
# sudo VOLUME /mnt/c/Users/cgsrj/trab-comp/trabalho-de-compiladores

RUN ls -la /