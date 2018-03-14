FROM szerencsi/lua:latest

RUN apt-get install -y curl zip unzip git

RUN luarocks install busted
RUN luarocks install classic
RUN luarocks install lua-cjson
