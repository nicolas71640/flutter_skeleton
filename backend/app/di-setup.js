const awilix = require('awilix');
const UserController = require('./controllers/user');
const Crypto = require('./controllers/utils/crypto')
const { OAuth2Client } = require('google-auth-library');
const CLIENT_ID = "133956385153-foniq2v586hk016ld1ms49r8kls1krca.apps.googleusercontent.com"
const client = new OAuth2Client(CLIENT_ID);
const jwt = require("jsonwebtoken");
const Mailer = require('./utils/mailer');
const nodemailer = require('nodemailer');


const container = awilix.createContainer({
  injectionMode: awilix.InjectionMode.PROXY,
});

function setup() {
  container.register({
    userController: awilix.asClass(UserController),
    oauthClient: awilix.asValue(client),
    crypto: awilix.asClass(Crypto),
    jwt: awilix.asValue(jwt),
    mailer: awilix.asValue(new Mailer(nodemailer)),
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