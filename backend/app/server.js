const express = require('express');
const apiErrorHandler = require('./error/api-error-handler');
const mongoose = require('mongoose');

//setup();
const router = require('./routes/user');

class Server {
  constructor() {
    this.app = express();
    this.setup();
  }

  setup() {
    this.app.use(express.json());
    this.app.use((req, res, next) => {
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
      next();
    });

    this.app.use('/api/auth', router);
    this.app.use(apiErrorHandler);

    mongoose.connect('mongodb://localhost:27017/myapp',
      {
        useNewUrlParser: true,
        useUnifiedTopology: true
      })
      .then(() => console.log('Connexion à MongoDB réussie !'))
      .catch(() => console.log('Connexion à MongoDB échouée !'));
  }

  run(port) {
    this.server = this.app.listen(port, () => {
      console.log(`server running on port ${port}`);
    });
  }

  stop(done) {
    this.server.close(done);
  }
}

module.exports = Server;