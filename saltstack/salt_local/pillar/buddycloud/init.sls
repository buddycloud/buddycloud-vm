buddycloud:
  lookup:
    domain: localhost.buddycloud.org                         # domain for buddycloud service
    env: dev
    git-branch: master
    web-listen-port: 443                                     # where to listen
    use_tls: false # enable TLS on web-listen-port  
    database-server: 127.0.0.1                               
    send-address: noreply@example.com
    smtp-server: smtp.example.com
    # DNS
    server-ip: 127.0.0.1
    ddns-server: 127.0.0.1
    tsigkeysecret: Cafgg7bVEnErJ95n143cBA==
    dns-checker-recipient: your-email@example.com
    # XMPP
    xmpp-component-secret: secret
    media-jid-password: mediaserver-test
    hosting-admin-username: hosting-admin-username           #appended to domain
    hosting-admin-password: hosting-admin-password
    # Pusher
    gcm.google_project_id: 732635300110
    gcm.api_key: ZIza1yA2rA9d4YfutCR1224UleLZhb_tGbV1wzVw
