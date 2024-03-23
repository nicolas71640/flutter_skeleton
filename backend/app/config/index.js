const convict = require('convict');
const credentials = require(`${process.env.CREDENTIALS_FOLDER}/credentials.json`);
const { client_secret, client_id} = credentials.installed;
const tokens = require(`${process.env.CREDENTIALS_FOLDER}/token.json`);
const { refresh_token } = tokens;
const oauth_config = require(`${process.env.CREDENTIALS_FOLDER}/oauth_config.json`);
const mongoUrl = process.env.MONGO_URL;

const config = convict({
    mongo:
    {
        url: mongoUrl
    },
    port: {
      doc: 'The port to bind.',
      format: 'port',
      default: 3000,
      env: 'PORT',
    },
    google_config: {
      user: oauth_config.user,
      client_id_android: oauth_config.android,
      client_id_ios: oauth_config.ios,
      client_id: client_id,
      client_secret: client_secret,
      refresh_token: refresh_token
    }
});

config.validate({ allowed: 'strict' });

module.exports = {
  ...config.getProperties(),
};