const User = require("../models/User")
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

function generateRefreshToken(user) {
    return jwt.sign({ userId: user._id }, "REFRESH_TOKEN_SECRET", { expiresIn: '1y' });
}

function generateAccessToken(user) {
    return jwt.sign({ userId: user._id }, "ACCESS_TOKEN_SECRET", { expiresIn: '5s' });
}

exports.signUp = (req, res, next) => {
    console.log("Signup")
    console.log(req.body)

    bcrypt.hash(req.body.password, 10)
        .then(hash => {
            const user = new User({
                email: req.body.email,
                password: hash
            });

            user.save()
                .then(() => { res.status(201).json({ message: "Utilisateur créé" }) })
                .catch((error) => { res.status(400).json({ error }) });
        })
        .catch((error) => {
            console.log(error)
            res.status(500).json({ error })
        })
}

exports.login = (req, res, next) => {
    console.log("login")

    User.findOne({ email: req.body.email })
        .then((user) => {
            if (!user) {
                return res.status(401).json({ error: 'utilisateur non trouvé' });
            }
            bcrypt.compare(req.body.password, user.password)
                .then(valid => {
                    if (!valid) {
                        return res.status(401).json({ error: 'Mot de passe incorrect' });
                    }

                    res.status(200).json({
                        email: user.email,
                        accessToken: generateAccessToken(user),
                        refreshToken: generateRefreshToken(user),
                    });
                })
                .catch((error) => {
                    console.log(error);

                    res.status(500).json({ error })
                });
        })
        .catch((error) => { res.status(500).json({ error }) });
}

const CLIENT_ID = "133956385153-foniq2v586hk016ld1ms49r8kls1krca.apps.googleusercontent.com"
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(CLIENT_ID);
async function verify(idToken) {
    const ticket = await client.verifyIdToken({
        idToken: idToken,
        requiredAudience: CLIENT_ID,
    });
    const payload = ticket.getPayload();
    return [payload['sub'], payload['email']];
}

exports.oauth = async (req, res, next) => {
    try {
        [userId, email] = await verify(req.body.idToken).catch(console.error);
        User.findOne({ email: email, userId: userId })
            .then((user) => {
                if (user) {
                    res.status(200).json({
                        email: user.email,
                        accessToken: generateAccessToken(user),
                        refreshToken: generateRefreshToken(user),
                    });
                }
                else {
                    const user = new User({
                        email: email,
                        userId: userId
                    });

                    

                    user.save()
                        .then(() => {
                            console.log("OAuth User Created");
                            res.status(200).json({
                                email: user.email,
                                accessToken: generateAccessToken(user),
                                refreshToken: generateRefreshToken(user),
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


exports.refreshToken = (req, res, next) => {
    console.log("refreshToken")

    const token = req.headers.authorization.split(' ')[1];
    const decodedToken = jwt.verify(token, "REFRESH_TOKEN_SECRET", (err, user) => {
        if (err) {
            return res.sendStatus(401)
        }
        console.log(user.userId)
        const refreshedToken = generateAccessToken(user.userId);
        console.log(refreshedToken)

        res.status(200).json({
            accessToken: refreshedToken,
        });

    });
}

exports.devDelete = (req, res, next) => {
    User.deleteOne({ email: req.body.email }).then(() => {
        res.status(200).json({
            message: 'Deleted!'
        });
    }
    );


}