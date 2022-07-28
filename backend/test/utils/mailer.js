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
            this.clearStub(nodemailer.createTransport);

        });

        describe('Mailer', () => {
            it('should send a mail with the expected parameters', () => {
                const email = "email@test.com"
                const newPassword = "newPassword"

                let transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: 'nicolas.lemble@gmail.com',
                        pass: 'h4Pf0Rgg83!'
                    }
                });
                var createTransport = sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");

                const mailer = new Mailer(nodemailer);

                mailer.sendNewPasswordEmail(email, newPassword);

                sinon.assert.calledWith(createTransport, sinon.match({
                    service: 'gmail',
                    auth: {
                        user: 'nicolas.lemble@gmail.com',
                        pass: 'h4Pf0Rgg83!'
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
                        user: 'nicolas.lemble@gmail.com',
                        pass: 'h4Pf0Rgg83!'
                    }
                });
                var createTransport = sinon.stub(nodemailer, "createTransport").returns(transporter);
                var sendMail = sinon.stub(transporter, "sendMail");

                const mailer = new Mailer(nodemailer);

                mailer.sendNewPasswordEmail(email, newPassword);

                let error = Error();

                this.chai.expect(function () { sendMail.getCall(0).args[1](error, null) }).to.throw(error);
            });
        });
    }
};
new MailerTest().run();