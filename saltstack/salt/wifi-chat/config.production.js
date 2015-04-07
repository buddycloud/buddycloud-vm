module.exports = {
  /* Which domains does this client handle - only affects account features */
  allowedDoamins: [ 'buddycloud.dev', 'example.com' ],

  /* Used for emails */
  url: 'http://localhost:3000',

  email: {
    /* Which address to send emails from */
    sendAddress: 'noreply@buddycloud.dev',
    /* Connection details */
    connection: {
      user: 'user',
      password: 'password',
      host: 'host',
      port: 'port', /* if not provided standard port used */
      ssl: 'ssl',  /* boolean or object {key, ca, cert} (if true or object, ssl connection will be made) */
      tls: true, /* boolean or object (if true or object, starttls will be initiated) */
      timeout: 5000 /* max number of milliseconds to wait for smtp responses (defaults to 5000) */
    }
  }
}
