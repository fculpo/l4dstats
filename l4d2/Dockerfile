FROM ubuntu:14.04
MAINTAINER Fabien Culpo <fabien.culpo@gmail.com>

RUN apt-get update && \
    apt-get install -y wget lib32gcc1

RUN useradd -ms /bin/bash steam
WORKDIR /home/steam

USER steam

#RUN chown -R steam:steam .

RUN wget -O /tmp/steamcmd_linux.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf /tmp/steamcmd_linux.tar.gz && \
    rm /tmp/steamcmd_linux.tar.gz

# Install/update L4D2
RUN ./steamcmd.sh \
          +login anonymous \
          +force_install_dir ./l4d2 \
          +app_update 222860 validate \
          +quit

# Add Source Mods
#ADD mods/mmsource-1.10.6-linux.tar.gz /home/steam/l4d2/left4dead2
#ADD mods/sourcemod-1.7.3-git5303-linux.tar.gz /home/steam/l4d2/left4dead2

# Add default configuration files
COPY cfg/ /home/steam/l4d2/left4dead2/cfg

EXPOSE 27015/udp
EXPOSE 27015/tcp

WORKDIR /home/steam/l4d2
CMD ["/home/steam/l4d2/srcds_run", "-game", "left4dead2", "-usercon", "-ip 0.0.0.0"]
