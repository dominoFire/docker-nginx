# Dockerfile para generar Imagen Docker que contiene NGINX
# La imagen se generó a partir de las instrucciones de 
# https://www.nginx.com/resources/wiki/start/topics/tutorials/install/

# Imagen inicial de donde nos basamos
# En este caso, usamos una imagen base con Ubuntu Xenial
FROM ubuntu:16.04
# Datos de autoria de esta imagen Docker
MAINTAINER Fernando Aguilar "fernando.aguilar@propiedades.com"

# El comando RUN nos sirve para correr comandos en el contenedor que crea la imagen
RUN echo "deb http://nginx.org/packages/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ xenial nginx" | tee -a /etc/apt/sources.list

# EL comanod ENV sirve para definir variables de entorno globales para la imagen
ENV NGINX_PUBLIC_KEY ABF5BD827BD9BF62

# Agregamos una llave criptografica para poder usar el repositorio APT de NGINX
# Note el uso de la variable de entorno definida anteriormente
RUN    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${NGINX_PUBLIC_KEY} \
    && gpg -a --export ${NGINX_PUBLIC_KEY} | apt-key add -

# En Ubuntu, usamos APT para instalar nuevos paquetes
# La opcion -y indica 'Si a todo', ya que no hay un humano escribiendo 'y'
# En este caso, dejamos que APT seleccione la versión más reciente y estable
# de NGINX para Ubuntu Xenial
RUN   apt-get update && apt-get install -y \
          nginx \
   && rm -rf /var/lib/apt/lists/*
# La ultima linea limpia el cache de APT, esto ayuda a hacer la imagen más ligera

# El comando EXPOSE le dice a Docker que esta imagen puede recibir paquetes de red.
# En este caso, recibe paquetes desde los puertos 80 y 433 **del contendor**
EXPOSE 80 443

# Hacemos una liga simbólica de los archivos del log a STDOUT y STDERR
# con el fin de poder ver en pantalla los mensajes de error de NGINX
# Basado en:
# https://github.com/nginxinc/docker-nginx/blob/25a3fc7343c6916fce1fba32caa1e8de8409d79f/stable/jessie/Dockerfile
RUN    ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


# El comando VOLUME le dice a Docker que un directorio de la imagen
# puede ser suplantado por otro directorio a través de varios mecanismos que 
# ofrece Docker Engine
# El caso más simple es montar un directorio de nuestro equipo host
# en el contenedor

# Hacemos montable este folder para poder servir contenido estático
VOLUME /usr/share/nginx/html

# Hacemos montable este folder para cambiar la configuración de NGINX
VOLUME /etc/nginx

# El comando CMD le dice a Docker qué es lo que tiene que correr
# cuando un usuario le da "docker run" a esta imagen.
# En este caso, corre NGINX en foreground
CMD ["nginx", "-g", "daemon off;"]
