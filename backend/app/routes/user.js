const express = require("express");
const router = express.Router();
const UserCtrl = require("../controllers/user");

router.post("/signup",UserCtrl.signUp);
router.post("/login",UserCtrl.login);

module.exports = router;