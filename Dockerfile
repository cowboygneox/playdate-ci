FROM ubuntu

ENV PLAYDATE_SDK_PATH /playdate
ENV PATH ${PATH}:${PLAYDATE_SDK_PATH}/bin

WORKDIR /playdate

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wget libpng-dev libgtk-3-0 libwebkit2gtk-4.0 xvfb dbus-x11

RUN wget https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-latest.tar.gz
RUN tar -zxf PlaydateSDK-latest.tar.gz -C ${PLAYDATE_SDK_PATH} --strip-components 1
RUN ./setup.sh

RUN mkdir luaunit
RUN mkdir /root/.Playdate\ Simulator

COPY docker-entrypoint.sh .
COPY framework/main.lua .
COPY framework/luaunit/luaunit.lua luaunit/
COPY framework/luaunit/playdate_luaunit_fix.lua luaunit/
COPY ["Playdate Simulator.ini", "/root/.Playdate Simulator/"]

WORKDIR /tests

ENTRYPOINT [ "/playdate/docker-entrypoint.sh" ]