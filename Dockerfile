FROM debian:stretch-slim

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 \
		lib32gcc1 \
		wget \
		ca-certificates \
	&& useradd -m steam \
	&& su steam -c \
		"mkdir -p /home/steam/steamcmd \
		&& cd /home/steam/steamcmd \
		&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Switch to user steam
USER steam

# Install L4d2 server
RUN set -x \
 ./home/steam/steamcmd/steamcmd.sh \
        +login anonymous \
        +force_install_dir /home/steam/l4d2 \
        +app_update 222860 validate \
        +quit

VOLUME /home/steam/steamcmd

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/l4d2 +app_update 222860 +quit && \
        ./home/steam/l4d2/srcds_run -ip 0.0.0.0 -exec server.cfg

# Expose ports
EXPOSE 0.0.0.0:27015:27015/udp 27015/tcp