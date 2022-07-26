const awilix = require('awilix');
const UserController = require('./controllers/user');
const Crypto = require('./controllers/utils/crypto')
const { OAuth2Client } = require('google-auth-library');
const CLIENT_ID = "133956385153-foniq2v586hk016ld1ms49r8kls1krca.apps.googleusercontent.com"
const client = new OAuth2Client(CLIENT_ID);


const container = awilix.createContainer({
  injectionMode: awilix.InjectionMode.PROXY,
});

function setup() {
  container.register({
    userController: awilix.asClass(UserController),
    oauthClient: awilix.asValue(client),
    crypto: awilix.asClass(Crypto)
  });
}

module.exports = {
  container,
  setup
};