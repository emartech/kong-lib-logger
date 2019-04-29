FROM emarsys/lua:latest

RUN yum update -y
RUN yum install -y \
    curl \
    git

RUN luarocks install busted
RUN luarocks install classic
RUN luarocks install lua-cjson
