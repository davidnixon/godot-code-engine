FROM docker.io/fedora:36
COPY Godot_v3.5.1-stable_linux_headless.64 /opt/godot-server
RUN useradd --create-home --gid 0 godot
USER godot
WORKDIR /home/godot

COPY --chown=godot:0 dist/ce-websocket-server.* .
COPY --chown=godot:0 entry.sh .
ENTRYPOINT ["/home/godot/entry.sh"]
CMD [ "/opt/godot-server", "--main-pack", "/home/godot/ce-websocket-server.pck" ]
