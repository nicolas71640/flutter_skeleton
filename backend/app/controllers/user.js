const config = require('../config');

class UserController {
    constructor({ oauthClient, crypto, User, jwt, mailer }) {
        this.oauthClient = oauthClient;
        this.crypto = crypto;
        this.User = User;
        this.jwt = jwt;
        this.mailer = mailer;

        this.signUp = this.signUp.bind(this);
        this.login = this.login.bind(this);
        this.oauth = this.oauth.bind(this);
        this.refreshToken = this.refreshToken.bind(this);
        this.forgetPassword = this.forgetPassword.bind(this);

        this.devDelete = this.devDelete.bind(this);
    }

    #generateRefreshToken(user) {
        return this.jwt.sign({ userId: user._id }, "REFRESH_TOKEN_SECRET", { expiresIn: '1y' });
    }

    #generateAccessToken(user) {
        return this.jwt.sign({ userId: user._id }, "ACCESS_TOKEN_SECRET", { expiresIn: '5s' });
    }

    #generateRandomPassword() {
        return Math.random().toString(36).slice(-8).toUpperCase();
    }

    async signUp(req, res, next) {
        console.log("Signup")
        console.log(req.body)

        this.crypto.hash(req.body.password, 10)
            .then(hash => {
                const user = new this.User({
                    email: req.body.email,
                    password: hash
                });

                user.save()
                    .then(() => { res.status(201).json({ message: "Utilisateur créé" }) })
                    .catch((error) => {
                        console.log(error);
                        res.status(400).json({ error })
                    });
            })
            .catch((error) => {
                console.log(error)
                res.status(500).json({ error })
            })
    }

    async login(req, res, next) {
        console.log("login")

        this.User.findOne({ email: req.body.email })
            .then((user) => {

                if (!user) {
                    return res.status(401).json({ error: 'utilisateur non trouvé' });
                }
                this.crypto.compare(req.body.password, user.password)
                    .then(valid => {
                        if (!valid) {
                            return res.status(401).json({ error: 'Mot de passe incorrect' });
                        }

                        res.status(200).json({
                            email: user.email,
                            accessToken: this.#generateAccessToken(user),
                            refreshToken: this.#generateRefreshToken(user),
                        });
                    })
                    .catch((error) => {
                        console.log(error);
                        res.status(500).json({ error })
                    });
            })
            .catch((error) => { res.status(500).json({ error }) });
    }


    async #verify(idToken) {
        const ticket = await this.oauthClient.verifyIdToken({
            idToken: idToken,
            audience: [config.google_config.client_id_android, config.google_config.client_id_ios],
        });
        const payload = ticket.getPayload();
        return [payload['sub'], payload['email']];
    }

    async oauth(req, res, next) {
        try {
            const [userId, email] = await this.#verify(req.body.idToken).catch(console.error);
            this.User.findOne({ email: email, userId: userId })
                .then((user) => {
                    if (user) {
                        console.log("OAuth User Already Exists");
                        res.status(200).json({
                            email: user.email,
                            accessToken: this.#generateAccessToken(user),
                            refreshToken: this.#generateRefreshToken(user),
                        });
                    }
                    else {
                        const user = new this.User({
                            email: email,
                            userId: userId
                        });

                        user.save()
                            .then(() => {
                                console.log("OAuth User Created");
                                res.status(200).json({
                                    email: user.email,
                                    accessToken: this.#generateAccessToken(user),
                                    refreshToken: this.#generateRefreshToken(user),
                                });
                            })
                            .catch((error) => { res.status(400).json({ error }) });
                    }
                })

        } catch (error) {
            console.log(error);
            res.status(500).json({ error })
        }
    }


    async refreshToken(req, res, next) {
        console.log("refreshToken")

        const token = req.headers.authorization.split(' ')[1];
        const decodedToken = this.jwt.verify(token, "REFRESH_TOKEN_SECRET", (err, user) => {
            if (err) {
                console.log(err);
                return res.sendStatus(401)
            }
            console.log(user.userId)
            const refreshedToken = this.#generateAccessToken(user.userId);
            console.log(refreshedToken)

            res.status(200).json({
                accessToken: refreshedToken,
            });

        });
    }

    async forgetPassword(req, res, next) {
        console.log("forgetPassword")

        this.User.findOne({ email: req.body.email, userId: null })
            .then((user) => {
                if (user) {
                    //  user found
                    const newPassword = this.#generateRandomPassword();

                    //Hash password
                    this.crypto.hash(newPassword, 10)
                        .then(hash => {

                            //Update User with new password hash
                            this.User.findOneAndUpdate({ email: req.body.email }, {
                                password: hash
                            })
                                .then(() => {
                                    console.log("Found the user, sending an email with new password")
                                    this.mailer.sendNewPasswordEmail(req.body.email, newPassword)
                                    return res.status(201).json({
                                        message: "ok"
                                    });
                                })
                                .catch((error) => {
                                    return res.status(500).json({ error })
                                });
                        })
                        .catch((error) => {
                            return res.status(500).json({ error })
                        });
                }
                else {
                    console.log("Couldn't find any user with this email")
                    return res.sendStatus(401)
                }
            }).catch((error) => {
                return res.status(500).json({ error })
            });
    }

    async devDelete(req, res, next) {
        console.log("devDelete")

        this.User.deleteOne({ email: req.body.email }).then(() => {
            res.status(200).json({
                message: 'Deleted!'
            });
        }
        );
    }

}

module.exports = UserController;
