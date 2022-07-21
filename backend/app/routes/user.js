const express = require("express");
const router = express.Router();
const UserCtrl = require("../controllers/user");

router.post("/signup",UserCtrl.signUp);
router.post("/login",UserCtrl.login);
router.post("/oauth",UserCtrl.oauth);

router.post("/refreshToken",UserCtrl.refreshToken);

if(process.env.DEV){
    router.post("/devDelete",UserCtrl.devDelete);
}
module.exports = router;