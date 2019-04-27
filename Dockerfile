FROM cm2network/steamcmd
LABEL maintainer="walentinlamonos@gmail.com"

# Run Steamcmd and install Squad
RUN set -x \
        && ./home/steam/steamcmd/steamcmd.sh \
        +login anonymous \
        +force_install_dir /home/steam/l4d2 \
        +app_update 222860 validate \
        +quit


VOLUME /home/steam/l4d2

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/l4d2 +app_update 222860 +quit && \
        ./home/steam/l4d2/srcds_run Port=27015

# Expose ports
EXPOSE 27015