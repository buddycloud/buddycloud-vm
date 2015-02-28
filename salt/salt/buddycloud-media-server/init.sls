# Pull the media-server image
buddycloud/media-server:
  docker.pulled:
    - tag: latest
    - force: True
    - require:
      - pip: docker-py
      - service: lxc-docker

# Remove the media-server container (stop and killed) if the image has changed
buddycloud-media-absent:
  cmd.wait:
    - name: docker rm -f media-server
    - onlyif: docker inspect media-server
    - watch:
      - docker: buddycloud/media-server

# Create a container
media-server-container:
  docker.installed:
    - name: media-server
    - image: buddycloud/media-server
    - ports:
      - '5000/tcp'
    - require:
      - docker: buddycloud/media-server
    - watch:
      - cmd: media-server-absent

# Run the container
media-server:
  docker.running:
    - container: 
    - port_bindings:
        "60001/tcp":
            HostIp: ""
            HostPort: "60001"
    - require:
      - docker: media-server-container
