FROM python:3.9
MAINTAINER Matthias Kuhn<matthias@opengis.ch>

RUN apt-get -y update \
  && apt-get install -y \
      gdal-bin \
  && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN pip install Shapely Pillow MapProxy uwsgi pyproj

EXPOSE 8080

ENV PROCESSES=4
ENV THREADS=10

ADD create_config.sh /bin/create_config.sh
ADD start.sh /start.sh

CMD /start.sh
