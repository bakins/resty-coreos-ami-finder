FROM ubuntu:trusty
ENV OPENRESTY_VERSION 1.7.10.1

RUN apt-get update && apt-get install -y curl build-essential git-core libpcre3-dev libssl-dev wget

RUN cd /tmp && \
    curl -L -O http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz && \
    tar -zxvf ngx_openresty-${OPENRESTY_VERSION}.tar.gz

RUN cd /tmp/ngx_openresty-${OPENRESTY_VERSION} &&\
    ./configure --prefix=/opt/openresty \
      --http-client-body-temp-path=/var/nginx/client_body_temp \
      --http-proxy-temp-path=/var/nginx/proxy_temp \
      --http-log-path=/var/nginx/access.log \
      --error-log-path=/var/nginx/error.log && \
    make && \
    make install

RUN mkdir -p /app && \
    cd /app && \
    git clone https://github.com/bakins/stardust.git && \
    cd stardust && \
    git checkout 2a6832b2ae1db33dcc2c1daf3226868309d50696

RUN cd /app && \
    git clone https://github.com/pintsized/lua-resty-http.git && \
    cd lua-resty-http && \
    git checkout 5be62c84fb809a3240a03fc76377831040955e19

ADD nginx.conf /app/
ADD app.lua /app/



