# This file is used to configure Buddycloud-stack components

buddycloud:
  lookup:
    # This will set your user's to appear on <username>@buddycloud.dev.
    domain: buddycloud.dev
    channels-xmpp-componet-password: channels-component-secret
    media-xmpp-componet-password: media-component-secret
    media-jid-password: media-jid-secret
    pusher-xmpp-componet-password: pusher-secret
    # if you are running on a public-IP and want your services accessible
    # uncomment below
    # external-ipv4:
    #  - 12.4.127.1
    # external-ipv6:
    #  - 2001:DEAD:BEEF::1
