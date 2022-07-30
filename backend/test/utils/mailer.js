//Require the dev-dependencies
const sinon = require("sinon");
const awilix = require('awilix');
const TestHelper = require('../test_helper');

const Mailer = require('../../app/utils/mailer');
const nodemailer = require('nodemailer');
const config = require('../../app/config');
const { OAuth2Client } = require('google-auth-library');



class MailerTest extends TestHelper {
    run() {
        afterEach(() => {
            this.clearStub(nodemailer.createTransport);
            this.clearStub(oauthClient.getAccessToken);
        });

        describe('Mailer', async () => {
            it('should send a mail with the expected parameters', async () => {
                const email = "email@test.com";
                const newPassword = "newPassword";
                const accessToken = "accessToken";
                const oauthClient = new OAuth2Client()
                const mailer = new Mailer(nodemailer, oauthClient);

                const transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        type: "OAuth2",
                        user: "nicolas.lemble@gmail.com",
                        clientId: config.google_config.client_id,
                        clientSecret: config.google_config.client_secret,
                        refreshToken: config.google_config.refresh_token,
                        accessToken: accessToken,
                    }
                });

                var getAccessToken = sinon.stub(oauthClient, "getAccessToken").resolves("accessToken");
                var createTransport = sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");


                await mailer.sendNewPasswordEmail(email, newPassword);

                sinon.assert.calledOnce(getAccessToken);
                sinon.assert.calledOnce(createTransport);
                sinon.assert.calledWith(createTransport, sinon.match({
                    service: 'gmail',
                    auth: {
                        type: "OAuth2",
                        user: "nicolas.lemble@gmail.com",
                        clientId: config.google_config.client_id,
                        clientSecret: config.google_config.client_secret,
                        refreshToken: config.google_config.refresh_token,
                        accessToken: accessToken,
                    }
                }));

                var mailOptions = {
                    from: 'nicolas.lemble@gmail.com',
                    to: email,
                    subject: 'New password created successfully',
                    text: newPassword
                };

                sinon.assert.calledWith(sendMail, sinon.match(mailOptions));

                sendMail.getCall(0).args[1](null, { response: "email" });
            });

            it('should throw an error if could not send the email', async () => {
                const email = "email@test.com"
                const newPassword = "newPassword"
                const oauthClient = new OAuth2Client()
                const mailer = new Mailer(nodemailer, oauthClient);

                const transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        type: "OAuth2",
                        user: "nicolas.lemble@gmail.com",
                        clientId: config.google_config.client_id,
                        clientSecret: config.google_config.client_secret,
                        refreshToken: config.google_config.refresh_token,
                        accessToken: "accessToken",
                    }
                });

                sinon.stub(oauthClient, "getAccessToken")
                sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");

                await mailer.sendNewPasswordEmail(email, newPassword);

                let error = Error();

                this.chai.expect(function () { sendMail.getCall(0).args[1](error, null) }).to.throw(error);
            });

            //Test to try that sending an email really works
            // it('should send an email', async () => {
            //     const { OAuth2Client } = require('google-auth-library');
            //     const config = require('../../app/config')

            //     const oauthClient = new OAuth2Client(
            //         config.google_config.client_id,
            //         config.google_config.client_secret
            //     )
            //     oauthClient.setCredentials({
            //         refresh_token: config.google_config.refresh_token
            //     });

            //     const email = "nicolas.lemble@gmail.com"
            //     const newPassword = "newPassword"

            //     const mailer = new Mailer(nodemailer, oauthClient);

            //     mailer.sendNewPasswordEmail(email, newPassword);

            //     // Check your gmail account to see if you've received an email
            // });
        });
    }
};
new MailerTest().run();