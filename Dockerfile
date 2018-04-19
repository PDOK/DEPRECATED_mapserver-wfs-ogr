FROM pdok/mapserver-wfs:0.1

COPY /etc/natura2000.map /srv/data/natura2000.map
COPY /etc/natura2000.gpkg /srv/data/natura2000.gpkg
COPY /etc/header.inc /srv/data/header.inc