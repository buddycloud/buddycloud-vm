# applied to all machines in your saltstack setup
base:
  '*':
    - buddycloud-vm-motd
    - sanity
    - time
    - groups
    - users
    - sudoers
    - node
    - sun-java
    - certificates
    - buddycloud-ddns
    - postgres   
    - nginx
    - prosody
    - buddycloud-server-java
    - buddycloud-http-api
    - buddycloud-media-server
    - buddycloud-pusher
    - buddycloud-webclient
    - buddycloud-angular-app
