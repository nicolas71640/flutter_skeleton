const convict = require('convict');
const credentials = require(`${process.env.CREDENTIALS_FOLDER}/credentials.json`);
const { client_secret, client_id} = credentials.installed;
const tokens = require(`${process.env.CREDENTIALS_FOLDER}/token.json`);
const { refresh_token } = tokens;
const client_ids = require(`${process.env.CREDENTIALS_FOLDER}/client_ids.json`);

const config = convict({
    port: {
      doc: 'The port to bind.',
      format: 'port',
      default: 3000,
      env: 'PORT',
    },
    google_config: {
      client_id_android: client_ids.android,
      client_id_ios: client_ids.ios,
      client_id: client_id,
      client_secret: client_secret,
      refresh_token: refresh_token
    }
});

config.validate({ allowed: 'strict' });

module.exports = {
  ...config.getProperties(),
};