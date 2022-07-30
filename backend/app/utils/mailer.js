const config = require('../config');


class Mailer {
    constructor(nodemailer, oauthClient) {
        this.nodemailer = nodemailer;
        this.oauthClient = oauthClient;

        this.sendNewPasswordEmail = this.sendNewPasswordEmail.bind(this);
    }

    async sendNewPasswordEmail(email, newPassword) {
        const accessToken = await this.oauthClient.getAccessToken();

        var transporter = this.nodemailer.createTransport({
            service: "gmail",
            auth: {
                type: "OAuth2",
                user: config.google_config.user,
                clientId: config.google_config.client_id,
                clientSecret: config.google_config.client_secret,
                refreshToken: config.google_config.refresh_token,
                accessToken: accessToken,
            }
        });

        var mailOptions = {
            from: config.google_config.user,
            to: email,
            subject: 'New password created successfully',
            text: newPassword
        };

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                throw error;
            } else {
                console.log('Email sent: ' + info.response);
            }
        });
    }
}


module.exports = Mailer