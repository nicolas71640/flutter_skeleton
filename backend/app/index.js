const { setup } = require('./di-setup');
setup();


const Server = require('./server');
const config = require('./config');
const server = new Server(config.port);


server.run(config.port);