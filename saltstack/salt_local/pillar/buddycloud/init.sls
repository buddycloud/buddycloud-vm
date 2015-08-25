buddycloud:
  lookup:
    domain: buddycloud.dev                                  # domain for buddycloud service
    database-server: 127.0.0.1                               
    ddns-server: 127.0.0.1                                  # setup scripts can automatically set DNS
    env: dev                                                # name of the environment (the vm-should use) 
    frontend-url: http://localhost:3000                     # where to serv
    git-branch: master                                      # which git branch to deploy from
    send-address: noreply@example.com
    smtp-server: smtp.example.com
    tsigkeyname: my-tsig-key                                  
    tsigkeysecret: txasdUhsdfTw7GqJwfpRlbA==
