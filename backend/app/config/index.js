const convict = require('convict');


const config = convict({
    port: {
      doc: 'The port to bind.',
      format: 'port',
      default: 3000,
      env: 'PORT',
    }
});

config.validate({ allowed: 'strict' });

module.exports = {
  ...config.getProperties(),
};