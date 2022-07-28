
class Mailer {
    constructor(nodemailer) {
        this.nodemailer = nodemailer;

        this.sendNewPasswordEmail = this.sendNewPasswordEmail.bind(this);
    }

    sendNewPasswordEmail(email, newPassword) {
        var transporter = this.nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: 'nicolas.lemble@gmail.com',
                pass: 'h4Pf0Rgg83!'
            }
        });

        var mailOptions = {
            from: 'sender mail address',
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