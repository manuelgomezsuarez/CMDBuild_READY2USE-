# CMDBuild_READY2USE

CMDBuild READY2USE para Docker


## Contenido

* [Pre-requisitos](#pre-requisitos)
* [Instalación](#instalación)
* [Conectar a CMDBuild](#conexión)

## Pre-Requisitos
* 16 GB RAM
* PostgreSQL (9.6 a 10.x)
* Docker
* Git

## Instalación

### 1. Clonar el repositorio

 ```
 git clone https://gitlabexp.chap.junta-andalucia.es/nexo/pi-interoperabilidad/cmdbuild_ready2use.git
 ```

### 2. Generar imagen

Ejecutar este comando al mismo nivel que se encuentra el README.md del repositorio descargado.

```
docker build . -t interoperabilidad/ready2use:1.0.0
```

Esto generará la imagen Docker para su posterior ejecución con el tag "interoperabilidad/ready2use:1.0.0".


### 3. Ejecutar imagen

Para la ejecución de la imagen usaremos el siguiente comando, sustituyendo las variables por las que correspondan.
```  
docker run --name ready2use  --restart unless-stopped -e CMDBUILD_DUMP="empty.dump.xz" -e POSTGRES_CMDBUILD_USER="cmdbuild" -e POSTGRES_CMDBUILD_PASS="cmdbuild" -e POSTGRES_DB="cmdbuild" -e POSTGRES_USER="postgres" -e POSTGRES_PASS="password" -e POSTGRES_PORT="5432" -e POSTGRES_HOST="localhost" -d interoperabilidad/ready2use:1.0.0
```
* CMDBUILD_DUMP: Lo dejaremos con el valor "empty.dump.xz" para que genere la estructura de la base de datos pero sin contenido. (Si no es la primera vez que ejecutamos, alertará en el Log que la base de datos ya existe y no borrará los datos existentes).
* POSTGRES_CMDBUILD_USER: Nombre de usuario que generará en Postgres para la aplicación.
* POSTGRES_CMDBUILD_PASS: Contraseña de usuario que generará en Postgres para la aplicación.
* POSTGRES_DB: Nombre de la base de datos que generará en Postgres para la aplicación.
* POSTGRES_USER: Usuario de Postgres con permisos de super-usuario para generar el usuario de la aplicación y la base de datos. (Por defecto en Postgres, el usuario es "postgres").
* POSTGRES_PASS: Contraseña de usuario de Postgres con permisos de super-usuario para generar el usuario de la aplicación y la base de datos.
* POSTGRES_PORT: Puerto de Postgres.
* POSTGRES_HOST: Host de Postgres.

`Nota:` Según en qué máquinas se encuentre Docker y Postgres tendremos que indicar en el comando de ejecución de Docker el Networking correcto.
https://docs.docker.com/network/

Por ejemplo, si tenemos docker y Postgres en la misma máquina, añadiremos al comando de docker run el parámetro: `--network=host`
Ejemplo:
```  
docker run --name ready2use  --restart unless-stopped -e CMDBUILD_DUMP="empty.dump.xz" -e POSTGRES_CMDBUILD_USER="cmdbuild" -e POSTGRES_CMDBUILD_PASS="cmdbuild" -e POSTGRES_DB="cmdbuild" -e POSTGRES_USER="postgres" -e POSTGRES_PASS="password" -e POSTGRES_PORT="5432" -e POSTGRES_HOST="localhost" --network=host -d interoperabilidad/ready2use:1.0.0
```


## Conexión

Una vez levanta el contenedor, conecta con la base de datos y despliega el war en Tomcat, podemos acceder desde:
http://localhost:8080/cmdbuild
Login: admin
Password: admin

La contraseña de admin la podemos modificar en el primer acceso y quedará guardada en Postgres aunque borremos y levantemos el contenedor de nuevo.

