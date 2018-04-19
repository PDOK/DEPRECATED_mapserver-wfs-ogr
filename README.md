# Mapserver WFS Geopackage

## Introduction
This project aims to fulfill two needs:
1. create a [OGC WFS](http://www.opengeospatial.org/standards/wfs) service that is deployable on a scalable infrastructure.
2. create a useable [Docker](https://www.docker.com) base image.

Fulfilling the first need the many purpose is to create an Docker base image that eventually can be run on a platform like [Kubernetes](https://kubernetes.io/).

Regarding the second need, finding a usable Mapserver Docker image is a challenge. Most images expose the &map=... QUERY_STRING in the getcapabilities, don't run in fastcgi and are based on Apache.

## Components
This stack is composed of the following:
* [Mapserver](http://mapserver.org/)
* [NGINX](https://www.nginx.com/)
* [Supervisor](http://supervisord.org/)

### Mapserver
Mapserver is the platform that will provide the WFS service.

### NGINX
NGINX is the web server we use to run Mapserver as a fastcgi web application. 

### Supervisor
Because we are running 2 processes (Mapserver CGI & NGINX) in a single Docker image we use Supervisor as a controller.

## Docker image

The Docker image contains 2 stages:
1. builder
2. Service

### builder
The builder stage compiles Mapserver. The Dockerfile contains all the available Mapserver build option explicitly, so it is clear which options are enabled and disabled. In this case the options like -DWITH_WFS are enabled and -DWITH_WMS are disabled, because we want only an WFS service.

### service
The service stage copies the Mapserver, build in the first stage, and configures NGINX and Supervisor.

## Usage

### Build
```
docker build -t pdok/mapserver-wfs-gkpg .
```

### Run
This image can be run straight from the commandline. A volumn needs to be mounted on the container directory /srv/data. The mounted volumn needs to contain a mapserver *.map file. The name of the mapfile will determine the URL path for the service.
```
docker run -d -p 80:80 --name mapserver-run-example -v /path/on/host:/srv/data pdok/mapserver-wfs-gpkg
```

Alternatively this image can be used as a Docker base image for an other Dockerfile, in which the necessay files are copied into the right directory (/srv/data)
```
FROM pdok/mapserver-wfs-gpkg

COPY /etc/example.map /srv/data/example.map
COPY /etc/example.gpkg /srv/data/example.gpkg
```
Running the example above will create a service on the url: http:/localhost/example/wfs? An working example can be found: https://github.com/PDOK/mapserver-wfs-gpkg/tree/natura2000-example

