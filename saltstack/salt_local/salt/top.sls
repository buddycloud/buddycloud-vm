# applied to all machines in your saltstack setup
base:
  '*':
    - buddycloud-vm-motd
    - buddycloud-general
    - sanity
    - time
    - groups
    - users
    - sudoers
    - bind
    - buddycloud-ddns
    - node
    - sun-java
    - postgres
    - nginx
    - prosody
    - buddycloud-server-java
    - buddycloud-http-api
    - buddycloud-media-server
    - buddycloud-pusher
    - buddycloud-angular-app
