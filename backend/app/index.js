const Server = require('./server');
const config = require('./config');
const { setup } = require('./di-setup');

setup();
const server = new Server(config.port);
server.run(config.port);