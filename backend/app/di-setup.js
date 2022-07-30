const awilix = require('awilix');
const UserController = require('./controllers/user');
const Crypto = require('./controllers/utils/crypto')
const { OAuth2Client } = require('google-auth-library');
const config = require('./config');

const client = new OAuth2Client(
  config.google_config.client_id,
  config.google_config.client_secret
)
const jwt = require("jsonwebtoken");
const Mailer = require('./utils/mailer');
const nodemailer = require('nodemailer');


const container = awilix.createContainer({
  injectionMode: awilix.InjectionMode.PROXY,
});

function setup() {
  client.setCredentials({
    refresh_token: config.google_config.refresh_token
  });

  container.register({
    userController: awilix.asClass(UserController),
    oauthClient: awilix.asValue(client),
    crypto: awilix.asClass(Crypto),
    jwt: awilix.asValue(jwt),
    mailer: awilix.asValue(new Mailer(nodemailer,client)),
  });

  container.loadModules([
    [
      './models/**/*.js',
      {
        register: awilix.asValue,
        lifetime: awilix.Lifetime.TRANSIENT
      }
    ],
  ], {
    cwd: __dirname,
    formatName: name => `${name.charAt(0).toUpperCase()}${name.substring(1)}`
  });


}

module.exports = {
  container,
  setup
};