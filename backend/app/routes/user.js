const express = require("express");
const UserController = require("../controllers/user");

const router = express.Router();
const userController = new UserController();

router.post("/signup",userController.signUp);
router.post("/login",userController.login);
router.post("/oauth",userController.oauth);
router.post("/refreshToken",userController.refreshToken);

if(process.env.DEV){
    router.post("/devDelete",userController.devDelete);
}
module.exports = router;