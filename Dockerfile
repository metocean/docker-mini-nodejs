FROM mhart/alpine-iojs-base
MAINTAINER Thomas Coats <thomas@metocean.co.nz>
ADD . /install/
RUN /install/install.sh
CMD ["/sbin/initjs"]