const express = require('express');
const StuffController = require('../controllers/stuff')
const auth = require('../middleware/auth');
const multer = require('../middleware/multer-config');

const router = express.Router();
const stuffController = new StuffController();

router.post('/', auth, multer, stuffController.createThing);
router.get('/', auth, stuffController.getAllThings);
router.get('/:id', auth, stuffController.getThing);
router.put('/:id', auth, multer, stuffController.modifyThing);
router.delete('/:id', auth, stuffController.deleteThing);

module.exports = router;
