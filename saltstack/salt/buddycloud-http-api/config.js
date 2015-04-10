exports._ = {
  port: 9123,
};

// Production settings
exports.production = {
  debug: true,
  channelDomain: 'channels.{{ salt['pillar.get']('buddycloud:lookup:domain') }}',
  xmppAnonymousDomain: 'anon.{{ salt['pillar.get']('buddycloud:lookup:domain') }}',
  pusherComponent: 'pusher.{{ salt['pillar.get']('buddycloud:lookup:domain') }}',
  friendFinderComponent: 'friend-finder.buddycloud.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://127.0.0.1:60080',
  createUserOnSessionCreation: true,
  logTransport: 'file',
  logFile: '/var/log/buddycloud-http-api/buddycloud-http-api.log',
  logLevel: 'debug',
  logUseJson: false
};

module.exports = {
  /* Which domains does this client handle - only affects account features */
  allowedDoamins: [ '{{ salt['pillar.get']('buddycloud:lookup:domain') }}', 'example.com' ],

  /* Used for emails */
  url: '{{ salt['pillar.get']('buddycloud:lookup:frontend-url') }}',

  email: {
    /* Which address to send emails from */
    sendAddress: '{{ salt['pillar.get']('buddycloud:lookup:send-address') }}',
    /* Connection details */
    connection: {
      user: 'user',
      password: 'password',
      host: '{{ salt['pillar.get']('buddycloud:lookup:smtp-server-address') }}',
      port: 'port', /* if not provided standard port used */
      ssl: 'ssl',  /* boolean or object {key, ca, cert} (if true or object, ssl connection will be made) */
      tls: true, /* boolean or object (if true or object, starttls will be initiated) */
      timeout: 5000 /* max number of milliseconds to wait for smtp responses (defaults to 5000) */
    }
  }
}
