const Cottage = require('../models/Cottage');
const fs = require('fs');

class CottageController {
  constructor() {
    this.getCottages = this.getCottages.bind(this);
  }

  async getCottages(req, res, next) {
    Cottage.find()
      .then(cottages => res.status(200).json(cottages))
      .catch(error => res.status(400).json({ error }));
  };

}

module.exports = CottageController;
