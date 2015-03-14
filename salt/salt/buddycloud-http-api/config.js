exports._ = {
  port: 9123,
};

// Production settings
exports.production = {
  debug: true,
  channelDomain: '#CHANNELS_XMPP_COMPONENT_SUBDOMAIN#',
  xmppAnonymousDomain: '#ANON_DOMAIN#',
  pusherComponent: 'pusher.buddycloud.com',
  friendFinderComponent: 'friend-finder.buddycloud.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://#BC_ENV_HOST#:60080',
  createUserOnSessionCreation: true,
  logTransport: 'file',
  logFile: '/var/log/buddycloud-http-api/buddycloud-http-api.log',
  logLevel: 'debug',
  logUseJson: false
};

