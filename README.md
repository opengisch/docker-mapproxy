# Mapproxy Dockerfile

A [docker](http://www.docker.com/) image that runs [mapproxy](http://mapproxy.org).

Exposes a mapproxy on port 8080.

This image comes

 - with support for [ogr based coverages](https://mapproxy.org/docs/nightly/coverages.html#coverages)
 - does not require su

## Quickstart

### Get the image

The [mapproxy image is published on dockerhub](https://hub.docker.com/r/opengisch/mapproxy).

### Create a sample configuration

Initialize a new sample configuration.
This will create a new subfolder `mapproxy` with a sample configuration in
your current working directory.
To create it somewhere else, change `$(pwd)` in the command below.

```
docker run --rm -v $(pwd):/io/config opengisch/mapproxy create_config.sh
```

### Run mapproxy

Configuration files are expected in the directory `/io/config`.
E.g. `/io/config/mapproxy.yaml`.

```
docker run --name "mapproxy" -p 8080:8080 -d -t -v $(pwd)/mapproxy:/io/config:ro opengisch/mapproxy
```

### docker-compose based deployment

Mapproxy by default puts the cache where the configuration lives.
For production use, you might want to change this, to keep the configuration
in a read-only volume and the cache in a read-write volume with different
requirements regarding backup, versioning etc.

docker-compose.yaml:
```yaml
services:
  # Map Proxy
  mapproxy:
    image: opengisch/mapproxy
    ports:
      - 8080
    volumes:
      - ./mapproxy:/io/config:ro
      - mapproxy-cache:/io/cache
    links:
      - qgis-server

  # QGIS server
  qgis-server:
    image:qgis-server:3.16-ubuntu
    environment:
      QGIS_SERVER_PARALLEL_RENDERING: "true"
      QGIS_SERVER_MAX_THREADS: 4
      QGIS_SERVER_LOG_LEVEL: 0
      # Limit the maximum size returned by a GetMap
      QGIS_SERVER_WMS_MAX_HEIGHT: 5000
      QGIS_SERVER_WMS_MAX_WIDTH: 5000
    volumes:
      - ./qgis-data:/io/data:ro
    ports:
      - 80
      
  # Nginx
  nginx:
    image: nginx:1.17.4
    links:
      - mapproxy
    restart: unless-stopped
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - 80:80
      
volumes:
  mapproxy-cache
```

nginx.conf
```
http {
  # ...
  server {
    # ...
    
    location /mapproxy {
      proxy_pass http://mapproxy:8080/mapproxy;
      proxy_set_header    Host            $http_host;
      proxy_set_header    X-Real-IP       $remote_addr;
      proxy_set_header    X-Forwarded-for $remote_addr;
      port_in_redirect off;
      proxy_connect_timeout 600;
      proxy_set_header X-Script-Name /mapproxy;
    }
  }
}
```

mapproxy.yaml:
```yaml
services:
layers:
caches:
sources:
grids:

globals:
  cache:
    meta_size: [6, 6]
    meta_buffer: 20
    base_dir: '/io/cache'
    lock_dir: '/io/cache/locks'
    # where to store lockfiles for tile creation
    tile_lock_dir: '/io/cache/tile_locks'
```

-----------

Matthias Kuhn (matthias@opengis.ch)

Heavily based on excellent work by

- Tim Sutton (tim@kartoza.com)
- Admire Nyakudya (admire@kartoza.com)
