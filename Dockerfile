FROM i386/debian:12.4-slim

# 1) INSTALL BASICS
RUN apt-get update && apt-get install -y wget libc6 libstdc++6 --force-yes

# 2) Create user
RUN groupadd -r hlds
RUN useradd --no-log-init --system --create-home --home-dir /server --gid hlds  hlds
USER hlds

# 3) Install HLDS 3.0.1.6
COPY install/hlds_l3016.tar.gz /server/
RUN tar -xzf /server/hlds_l3016.tar.gz -C /server && rm /server/hlds_l3016.tar.gz

#Copy required files
COPY install/nowon.so /server/hlds_l/
COPY install/hlds_start /server/hlds_l/

#-------------------------------
WORKDIR /server/hlds_l/

USER root

# INSTALL modified HLDS_RUN
COPY ./install/hlds_start /server/hlds_l/
COPY ./install/nowon.so /server/hlds_l/
COPY ./install/nowon_patch.sh /server/hlds_l/
RUN chmod +x nowon_patch.sh && ./nowon_patch.sh

#Install WON2 masterserver
COPY config/valve/* ./valve/

RUN chmod +x hlds_l
RUN chmod +x hlds_start

# Then, remove default mod folders
RUN rm -rf ./tfc

USER hlds

ENV TERM xterm

ENTRYPOINT ["./hlds_start"]

CMD ["-game valve", "+map crossfire", "+maxplayers 16"]