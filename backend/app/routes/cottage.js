const express = require('express');
const CottageController = require('../controllers/cottage')
const auth = require('../middleware/auth');

const router = express.Router();
const cottageController = new CottageController();

router.get('/', auth, cottageController.getCottages);

module.exports = router;
