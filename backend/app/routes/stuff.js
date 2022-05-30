const express = require('express');
const router = express.Router();
const StuffCtrl = require('../controllers/stuff')
const auth = require('../middleware/auth');
const multer = require('../middleware/multer-config');

router.post('/', auth, multer, StuffCtrl.createThing);
router.get('/', auth, StuffCtrl.getAllThings);
router.get('/:id', auth, StuffCtrl.getThing);
router.put('/:id', auth, multer, StuffCtrl.modifyThing);
router.delete('/:id', auth, StuffCtrl.deleteThing);

module.exports = router;
