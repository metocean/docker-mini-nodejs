FROM mhart/alpine-iojs-base
MAINTAINER Thomas Coats <thomas@metocean.co.nz>
ADD . /install/
RUN /install/install.sh
CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]