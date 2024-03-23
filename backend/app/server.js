const config = require('./config');
const express = require('express');
const apiErrorHandler = require('./error/api-error-handler');
const mongoose = require('mongoose');

const UserRoutes = require('./routes/user');
const StuffRoutes = require('./routes/stuff');
const CottageRoutes = require('./routes/cottage');

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

    this.app.use('/api/auth', UserRoutes);
    this.app.use('/api/stuff',StuffRoutes);
    this.app.use('/api/cottage',CottageRoutes);

    this.app.use(apiErrorHandler);
   
    mongoose.set('strictQuery', false);
    mongoose.connect(config.mongo.url,
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