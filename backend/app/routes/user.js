const express = require("express");
const { container } = require('../di-setup');

const router = express.Router();
const userController = container.resolve('userController');

router.post("/signup",userController.signUp);
router.post("/login",userController.login);
router.post("/oauth",userController.oauth);
router.post("/refreshToken",userController.refreshToken);
router.post("/forgetPassword",userController.forgetPassword);

if(process.env.DEV){
    router.post("/devDelete",userController.devDelete);
}
module.exports = router;