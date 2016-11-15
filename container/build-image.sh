#! /bin/bash

# Setteamos esta bandera para interrumpir la ejecución
# del script en caso de un comando fallido
set -e 

# Hacemos sourcing del script de la definición de variables
# para el contenedor
source container/vars.sh

# Con este comando construimos la imagen Docker y le asignamos
# el nombre de la imagen
docker build . -t ${IMAGE_NAME}
