//Require the dev-dependencies
const sinon = require("sinon");
const awilix = require('awilix');
const TestHelper = require('../test_helper');

const Mailer = require('../../app/utils/mailer');
const nodemailer = require('nodemailer');
const SMTPTransport = require("nodemailer/lib/smtp-transport");


class MailerTest extends TestHelper {
    run() {
        afterEach(() => {
            this.clearStub(nodemailer.createTransport);
        });

        describe('Mailer', () => {
            it('should send a mail with the expected parameters', () => {
                const email = "email@test.com"
                const newPassword = "newPassword"

                let transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: 'michel.martin6871@gmail.com',
                        pass: 'h4Pf0Rar83'
                    }
                });
                var createTransport = sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");

                const mailer = new Mailer(nodemailer);

                mailer.sendNewPasswordEmail(email, newPassword);

                sinon.assert.calledWith(createTransport, sinon.match({
                    service: 'gmail',
                    auth: {
                        user: 'michel.martin6871@gmail.com',
                        pass: 'h4Pf0Rar83'
                    }
                }));

                var mailOptions = {
                    from: 'sender mail address',
                    to: email,
                    subject: 'New password created successfully',
                    text: newPassword
                };

                sinon.assert.calledWith(sendMail, sinon.match(mailOptions));

                sendMail.getCall(0).args[1](null, { response: "email" });
            });

            it('should throw an error if could not send the email', () => {
                const email = "email@test.com"
                const newPassword = "newPassword"

                let transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: 'michel.martin6871@gmail.com',
                        pass: 'h4Pf0Rar83'
                    }
                });
                var createTransport = sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");

                const mailer = new Mailer(nodemailer);

                mailer.sendNewPasswordEmail(email, newPassword);

                let error = Error();

                this.chai.expect(function () { sendMail.getCall(0).args[1](error, null) }).to.throw(error);
            });

            //Test to try that sending an email really works
            it('should send an email', async () => {
                const { OAuth2Client } = require('google-auth-library');
                const config = require('../../app/config')

                const oauthClient = new OAuth2Client(
                    config.google_config.client_id,
                    config.google_config.client_secret
                )
                oauthClient.setCredentials({
                    refresh_token: config.google_config.refresh_token
                });

                const email = "nicolas.lemble@gmail.com"
                const newPassword = "newPassword"

                const mailer = new Mailer(nodemailer, oauthClient);

                mailer.sendNewPasswordEmail(email, newPassword);

                // Check your gmail account to see if you've received an email
            });
        });
    }
};
new MailerTest().run();