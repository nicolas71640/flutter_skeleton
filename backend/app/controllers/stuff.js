const Thing = require('../models/Thing');
const fs = require('fs');

class StuffController {
  constructor() {    
    this.createThing = this.createThing.bind(this);
    this.modifyThing = this.modifyThing.bind(this);
    this.deleteThing = this.deleteThing.bind(this);
    this.getAllThings = this.getAllThings.bind(this);
    this.getThing = this.getThing.bind(this);
  }

  async createThing(req, res, next) {
    const thingObject = JSON.parse(req.body.thing);
    delete thingObject._id;
    const thing = new Thing({
      ...thingObject,
      imageUrl: `${req.protocol}://${req.get('host')}/images/${req.file.filename}`
    });
    thing.save()
      .then(() => res.status(201).json({ message: 'Objet enregistré !' }))
      .catch(error => res.status(400).json({ error }));
  };

  async modifyThing(req, res, next) {
    const thingObject = req.file ? {
      ...JSON.parse(req.body.thing),
      imageUrl: `${req.protocol}://${req.get('host')}/images/${req.file.filename}`
    } : { ...req.body };

    Thing.updateOne({ _id: req.params.id }, { ...thingObject, _id: req.params.id })
      .then(() => res.status(200).json({ message: 'Objet modifié !' }))
      .catch(error => res.status(400).json({ error }));
  };

  async deleteThing(req, res, next) {
    Thing.findOne({ _id: req.params.id }).then(
      (thing) => {
        if (!thing) {
          res.status(404).json({
            error: new Error('No such Thing!')
          });
        }
        if (thing.userId !== req.auth.userId) {
          res.status(400).json({
            error: new Error('Unauthorized request!')
          });
        }
        const filename = thing.imageUrl.split('/images/')[1];
        fs.unlink(`images/${filename}`, () => {
          Thing.deleteOne({ _id: req.params.id }).then(
            () => {
              res.status(200).json({
                message: 'Deleted!'
              });
            }
          ).catch(
            (error) => {
              res.status(400).json({
                error: error
              });
            }
          );
        })
      }
    )
  };

  async getAllThings(req, res, next) {
    Thing.find()
      .then(things => res.status(200).json(things))
      .catch(error => res.status(400).json({ error }));
  };

  async getThing(req, res, next) {
    Thing.findOne({ _id: req.params.id })
      .then(things => res.status(200).json(things))
      .catch(error => res.status(400).json({ error }));
  }
}

module.exports = StuffController;
