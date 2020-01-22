FROM mhart/alpine-node:13
MAINTAINER Troy Mare <t.mare@metocean.co.nz>
ADD . /install/
RUN /install/install.sh
CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]
