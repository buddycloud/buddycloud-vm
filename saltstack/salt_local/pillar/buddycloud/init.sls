buddycloud:
  lookup:
    domain: buddycloud.dev                                  # domain for buddycloud service
    env: dev
    git-branch: master
    web-listen-port: 8080                                    # where to listen
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
    hosting-admin-username: hosting-admin-username    #appended to domain
    hosting-admin-password: hosting-admin-password
