# Pull the http-api image
buddycloud/http-api-server:
  docker.pulled:
    - tag: latest
    - force: True
    - require:
      - pip: docker-py
      - service: lxc-docker

# Remove the http-api container (stop and killed) if the image has changed
buddycloud-http-api-server-absent:
  cmd.wait:
    - name: docker rm -f http-api-server
    - onlyif: docker inspect http-api-server
    - watch:
      - docker: buddycloud/http-api-server

# Create a container
http-api-server-container:
  docker.installed:
    - name: http-api-server
    - image: buddycloud/http-api-server
    - ports:
      - '5000/tcp'
    - require:
      - docker: buddycloud/http-api-server
    - watch:
      - cmd: http-api-server-absent

# Run the container
http-api-server:
  docker.running:
    - container: 
    - port_bindings:
        "60001/tcp":
            HostIp: ""
            HostPort: "60001"
    - require:
      - docker: http-api-server-container
