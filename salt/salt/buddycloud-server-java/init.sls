# Pull the channel-server image
buddycloud/channel-server:
  docker.pulled:
    - tag: latest
    - force: True
    - require:
      - pip: docker-py
      - service: lxc-docker

# Remove the channel-server container (stop and killed) if the image has changed
channel-server-absent:
  cmd.wait:
    - name: docker rm -f channel-server
    - onlyif: docker inspect channel-server
    - watch:
      - docker: buddycloud/channel-server

# Create a container
channel-server-container:
  docker.installed:
    - name: channel-server
    - image: buddycloud/channel-server
    - ports:
      - '5000/tcp'
    - require:
      - docker: buddycloud/channel-server
    - watch:
      - cmd: channel-server-absent

# Run the container
channel-server:
  docker.running:
    - container: 
    - port_bindings:
        "5000/tcp":
            HostIp: ""
            HostPort: "5000"
    - require:
      - docker: channel-server-container
