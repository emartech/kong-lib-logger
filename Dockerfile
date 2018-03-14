FROM szerencsi/lua:latest

RUN apt-get install -y curl

RUN luarocks install busted
RUN luarocks install classic
RUN luarocks install lua-cjson
