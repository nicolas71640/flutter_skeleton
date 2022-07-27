const { setup } = require('./di-setup');
setup();


const Server = require('./server');
const config = require('./config');
const server = new Server(process.env.PORT || config.port);


server.run(process.env.PORT ||  config.port);