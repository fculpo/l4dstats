FROM ubuntu:14.04
MAINTAINER Fabien Culpo <fabien.culpo@gmail.com>

RUN groupadd -r steam \
    && useradd -r -g steam steam \
    && mkdir -p /opt/steam \
    && chown -R steam:steam /opt/steam

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    lib32gcc1 \   
    ca-certificates \
    wget \
    lib32z1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION 1.7
RUN set -x \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

WORKDIR /opt/steam

# Install SteamCMD
RUN wget -O /tmp/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && gosu steam tar -xvzf /tmp/steamcmd_linux.tar.gz \
    && gosu steam /opt/steam/steamcmd.sh +@ShutdownOnFailedCommand 1 +quit \
    && rm -rf /opt/steam/Steam/logs /opt/steam/Steam/appcache/httpcache \
    && find /opt/steam/package -type f ! -name "steam_cmd_linux.installed" ! -name "steam_cmd_linux.manifest" -delete \
    && rm /tmp/steamcmd_linux.tar.gz

# Install/update L4D2
RUN gosu steam /opt/steam/steamcmd.sh \
      +@ShutdownOnFailedCommand 1 \    
      +login anonymous \
      +force_install_dir ./l4d2 \
      +app_update 222860 validate \
      +quit \
    && rm -rf /opt/steam/Steam/logs /opt/steam/Steam/appcache/httpcache \
    && find /opt/steam/package -type f ! -name "steam_cmd_linux.installed" ! -name "steam_cmd_linux.manifest" -delete

# Install Metamod and Sourcemod
WORKDIR /opt/steam/l4d2/left4dead2

COPY mods/mmsource-1.10.6-linux.tar.gz /tmp/mods/mmsource-1.10.6-linux.tar.gz
COPY mods/sourcemod-1.7.3-git5303-linux.tar.gz /tmp/sourcemod-1.7.3-git5303-linux.tar.gz

RUN gosu steam tar -xvzf /tmp/mods/mmsource-1.10.6-linux.tar.gz && \
    gosu steam tar -xvzf /tmp/sourcemod-1.7.3-git5303-linux.tar.gz && \
    rm -rf /tmp/mods/mmsource-1.10.6-linux.tar.gz && \
    rm -rf /tmp/sourcemod-1.7.3-git5303-linux.tar.gz

# Add default configuration files
COPY cfg/ /opt/steam/l4d2/left4dead2/cfg

# Copy entrypoint
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 27015/udp
EXPOSE 27015/tcp

WORKDIR /opt/steam

ENTRYPOINT ["/entrypoint.sh"]
CMD ["l4d2"]
