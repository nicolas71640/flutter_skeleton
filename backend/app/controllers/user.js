class UserController {
    constructor({ oauthClient, crypto, User, jwt}) {    
        this.oauthClient = oauthClient;
        this.crypto = crypto;
        this.User = User;
        this.jwt = jwt;

        this.signUp = this.signUp.bind(this);
        this.login = this.login.bind(this);
        this.oauth = this.oauth.bind(this);
        this.refreshToken = this.refreshToken.bind(this);
        this.devDelete = this.devDelete.bind(this);
      }

    #generateRefreshToken(user) {
        return this.jwt.sign({ userId: user._id }, "REFRESH_TOKEN_SECRET", { expiresIn: '1y' });
    }

    #generateAccessToken(user) {
        return this.jwt.sign({ userId: user._id }, "ACCESS_TOKEN_SECRET", { expiresIn: '5s' });
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
            requiredAudience: this.oauthClient._clientId,
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


    async refreshToken (req, res, next) {
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
