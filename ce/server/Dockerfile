FROM docker.io/fedora:36
COPY Godot_v3.5.1-stable_linux_headless.64 /opt/godot-server
USER 1024
WORKDIR /home/app

# Add Tini
ENV TINI_VERSION v0.19.0
ADD --chown=1024:0 https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

COPY dist/ce-websocket-server.* .
CMD [ "/opt/godot-server", "--main-pack", "/home/app/ce-websocket-server.pck" ]
