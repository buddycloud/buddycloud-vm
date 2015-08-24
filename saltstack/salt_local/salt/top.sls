# applied to all machines in your saltstack setup
base:
  '*':
    - buddycloud-vm-motd
    - sanity
    - time
    - groups
    - users
    - sudoers
    - certificates
#    - buddycloud-ddns
    - postgres   
    - nginx
    - node
    - prosody
    - sun-java
    - buddycloud-server-java
    - buddycloud-http-api
    - buddycloud-media-server
    - buddycloud-pusher
    - buddycloud-webclient
    - buddycloud-angular-app
