# Práctica de CI/CD - Docker > GitHub Actions > GHCR > DockerHub > Render

Repo original de cátedra: [dds-devops](https://github.com/sergioviera/dds-devops)

## Objetivo
Construir una aplicación web sencilla, verificarla y publicar una imagen de contenedor identificada por el commit de Git.

## Requisitos
- Docker instalado y funcionando para la prueba local.
- Cuenta de GitHub y repositorio público con rama `main`.
- Cuenta de DockerHub y repositorio público.
- Cuenta de Render y proyecto.

## Parte 1: CI en GitHub

Configurar GitHub Actions para, cuando se realice un *push* a la rama `main`, GitHub construya una imagen del repositorio y la guarde en GHCR (*GitHub Container Registry*).

### Paso 1 - Docker local
```bash
docker build -t dds-devops-demo:local .
docker run --rm -p 8080:80 dds-devops-demo:local
```
Abrir http://localhost:8080 y verificar el mensaje **Hola DevOps**.

### Paso 2 - GitHub Actions
Crear un repositorio público, subir todos los archivos manteniendo las carpetas, y realizar un push a `main`.
Ir a **Actions** y verificar que termine correctamente el workflow **CI - Docker y GHCR**.

### Paso 3 - GitHub Container Registry
En GitHub, abrir la página principal del repositorio y ubicar **Packages** en el panel lateral derecho. Allí debería aparecer el paquete publicado. También puede consultarse desde la sección **Packages** del perfil de la cuenta u organización propietaria. La imagen se identifica como `ghcr.io/USUARIO/REPOSITORIO:SHA_CORTO` (siete caracteres).

**Importante**: un paquete GHCR recién publicado puede ser privado aun si el repositorio es público. Para permitir descargas anónimas, abrir los ajustes del paquete y cambiar su visibilidad a público. Esta operación es distinta de hacer público el repositorio.

Ejecutar la imagen publicada desde una máquina con Docker:
```bash
docker run --rm -p 8081:80 ghcr.io/USUARIO/REPOSITORIO:SHA_CORTO
```
Si la imagen todavía no existe localmente, Docker la descargará automáticamente desde GHCR antes de iniciar el contenedor. Abrir http://localhost:8081 y verificar que se muestra la aplicación. Si la imagen es privada, será necesario autenticarse antes de ejecutarla.

## Parte 2: CI en GitHub y DockerHub
Se debe ampliar el proceso de integración continua (CI) desarrollado en la práctica anterior, incorporando Docker Hub como un segundo registro de contenedores.

El objetivo es comprender cómo una misma imagen Docker puede distribuirse mediante diferentes servicios, sin necesidad de modificar el código fuente de la aplicación ni su Dockerfile.

A partir del proyecto utilizado en la práctica anterior:

1. **Docker Hub:** Crear una cuenta en Docker Hub, si todavía no disponen de una, y un repositorio público para publicar la imagen.
2. **GitHub Secrets:** Configurar en GitHub las variables y credenciales necesarias para autenticarse en Docker Hub.
3. **Modificar el workflow** de GitHub Actions para que construya y valide la imagen una sola vez, y luego la publique tanto en GHCR como en Docker Hub.
4. Publicar la imagen utilizando dos etiquetas: latest y una asociada al commit.
5. Verificar que ambas imágenes estén disponibles y puedan ejecutarse localmente mediante docker run.

## Parte 3: CD en Render
Render: servicio de computación en la nube que soporta despliegues continuos. 

https://dashboard.render.com/