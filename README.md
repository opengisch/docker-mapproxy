# Mapproxy Dockerfile

A [docker](http://www.docker.com/) image that runs [mapproxy](http://mapproxy.org).

Exposes a mapproxy on port 8080.

## Quickstart

### Get the image

The [mapproxy image is published on dockerhub](https://hub.docker.com/r/opengisch/mapproxy).

### Create a sample configuration

Initialize a new sample configuration.
This will create a new subfolder `mapproxy` with a sample configuration in
your current working directory.

```
docker run --rm -v $(pwd):/io/config opengisch/mapproxy create_config.sh
```

### Run mapproxy

```
docker run --name "mapproxy" -p 8080:8080 -d -t -v $(pwd)/mapproxy:/io/config:ro opengisch/mapproxy
```

Once the service is up and running you can connect to the default demo
mapproxy service by pointing QGIS' WMS client to the mapproxy service.
In the example below the nginx container is running on 
``localhost`` on port 8080.

```
http://localhost:8080/mapproxy/service/?
```

-----------

Matthias Kuhn (matthias@opengis.ch)

Heavily based on excellent work by

- Tim Sutton (tim@kartoza.com)
- Admire Nyakudya (admire@kartoza.com)
