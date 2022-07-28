//Require the dev-dependencies
const TestHelper = require('../test_helper');
const sinon = require("sinon");
const awilix = require('awilix');

//Other
const { OAuth2Client } = require('google-auth-library');
const { LoginTicket } = require('google-auth-library');
const Crypto = require('../../app/controllers/utils/crypto');
const User = require('../../app/models/User');
const { expect } = require('chai');
const Mailer = require('../../app/utils/mailer');
const nodemailer = require('nodemailer')



class AuthTest extends TestHelper {
    setup() {
        this.client = new OAuth2Client("CLIENT_ID");
        this.ticket = new LoginTicket();
        this.crypto = new Crypto();
        this.User = User;
        this.mailer = new Mailer(nodemailer);

        this.register({
            oauthClient: awilix.asValue(this.client),
            crypto: awilix.asValue(this.crypto),
            User: awilix.asValue(User),
            mailer: awilix.asValue(this.mailer),
        });

    }

    run() {
        describe('SignUp', () => {
            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            afterEach(() => {
                this.clearStub(this.crypto.hash);
            });

            it('should Register user and then login without error', (done) => {
                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(201);

                        // follow up with login
                        this.chai.request(this.app)
                            .post('/api/auth/login')
                            .send({
                                'email': 'tester@gmail.com',
                                'password': 'tester'
                            })
                            .end((err, res) => {
                                res.body.should.have.property('accessToken');
                                res.body.should.have.property('refreshToken');
                                var token = res.body.token;
                                done();
                            });
                    })
            })

            it('should fail to register user when a user already exists', (done) => {
                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(201);

                        this.chai.request(this.app)
                            .post('/api/auth/signup')
                            .send({
                                'email': 'tester@gmail.com',
                                'password': 'tester'
                            })
                            .end((err, res) => {
                                res.should.have.status(400);
                                done();
                            });
                    })
            })

            it('should fail with error 500 when the crypto throws an error', (done) => {

                sinon.stub(this.crypto, "hash").rejects('Error when hashing');

                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(500);
                        done();
                    })
            })
        });

        describe('Login', () => {

            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            afterEach(() => {
                this.clearStub(this.crypto.compare);
                this.clearStub(this.User.findOne);
            });

            it('should return error 500 when the user does not exist', (done) => {
                this.chai.request(this.app)
                    .post('/api/auth/login')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(401);
                        done();
                    });
            });

            it('should fail with error 401 when password is wrong', (done) => {
                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(201);

                        // follow up with login
                        this.chai.request(this.app)
                            .post('/api/auth/login')
                            .send({
                                'email': 'tester@gmail.com',
                                'password': 'wrong_password'
                            })
                            .end((err, res) => {
                                res.should.have.status(401);
                                done();
                            });
                    })
            })

            it('should fail with error 500 when the crypto throws an error', (done) => {

                sinon.stub(this.crypto, "compare").rejects('Error when comparing');
                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        this.chai.request(this.app)
                            .post('/api/auth/login')
                            .send({
                                'email': 'tester@gmail.com',
                                'password': 'tester'
                            })
                            .end((err, res) => {
                                res.should.have.status(500);
                                done();
                            })
                    });
            })

            it('should fail with error 500 when mongoose return an error', (done) => {

                sinon.stub(this.User, "findOne").rejects('Error when comparing');
                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        this.chai.request(this.app)
                            .post('/api/auth/login')
                            .send({
                                'email': 'tester@gmail.com',
                                'password': 'tester'
                            })
                            .end((err, res) => {
                                res.should.have.status(500);
                                done();
                            })
                    });
            })
        })

        describe('OAuth', () => {


            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });


            afterEach(() => {
                this.clearStub(this.client.verifyIdToken);
                this.clearStub(this.ticket.getPayload);
            });

            it('should return error 500 when an error is thrown by google signin', (done) => {
                sinon.stub(this.client, "verifyIdToken").throws(Error())

                this.chai.request(this.app)
                    .post('/api/auth/oauth')
                    .send({
                        'idToken': 'myIdToken',
                    })
                    .end((err, res) => {
                        res.should.have.status(500);
                        done();
                    });
            });

            it('should return 200 when the user does not exists', (done) => {
                sinon.stub(this.ticket, "getPayload").returns({ sub: 'userId', email: 'test@gmail.com' });
                sinon.stub(this.client, "verifyIdToken").returns(this.ticket);

                this.chai.request(this.app)
                    .post('/api/auth/oauth')
                    .send({
                        'idToken': 'myIdToken',
                    })
                    .end((err, res) => {
                        res.should.have.status(200);
                        done();
                    });
            });

            it('should return 200 when the user does exists', (done) => {
                sinon.stub(this.ticket, "getPayload").returns({ sub: 'userId', email: 'test@gmail.com' });
                sinon.stub(this.client, "verifyIdToken").returns(this.ticket);

                this.chai.request(this.app)
                    .post('/api/auth/oauth')
                    .send({
                        'idToken': 'myIdToken',
                    })
                    .end((err, res) => {
                        this.chai.request(this.app)
                            .post('/api/auth/oauth')
                            .send({
                                'idToken': 'myIdToken',
                            })
                            .end((err, res) => {
                                res.should.have.status(200);
                                done();
                            });
                    });
            });

            it('should return 400 when the mail already exists in the database and is not oauth', (done) => {
                sinon.stub(this.ticket, "getPayload").returns({ sub: 'userId', email: 'tester@gmail.com' });
                sinon.stub(this.client, "verifyIdToken").returns(this.ticket);

                this.chai.request(this.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        this.chai.request(this.app)
                            .post('/api/auth/oauth')
                            .send({
                                'idToken': 'myIdToken',
                            })
                            .end((err, res) => {
                                res.should.have.status(400);
                                done();
                            });
                    });
            });
        });

        describe('refreshToken', () => {
            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should return status 200 when no the refresh token is correct', async () => {
                const [, refreshToken] = await this.login();

                this.chai.request(this.app)
                    .post('/api/auth/refreshToken')
                    .set('authorization', 'bearer ' + refreshToken)
                    .end((err, res) => {
                        res.should.have.status(200);
                    });
            });

            it('should return status 401 when then refresh token is wrong', async () => {
                const [accessToken] = await this.login();

                //Putting accessToken instead of refreshToken to throw an error
                this.chai.request(this.app)
                    .post('/api/auth/refreshToken')
                    .set('authorization', 'bearer ' + accessToken)
                    .end((err, res) => {
                        res.should.have.status(401);
                    });
            });
        });

        describe('forgetPassword', () => {

            beforeEach((done) => {
                this.User.remove({}, (err) => {
                    done();
                });
            });

            afterEach(() => {
                this.clearStub(this.crypto.hash);
                this.clearStub(this.User.findOne);
                this.clearStub(this.User.findOneAndUpdate);

            });

            it('should send status 201 and send and email if user is found', async () => {
                var sendNewPasswordEmail = sinon.stub(this.mailer, "sendNewPasswordEmail");
                
                const user = new this.User({
                    email: "tester@gmail.com",
                    password: "passwordHash"
                });

                await user.save();

                const res = await this.chai.request(this.app)
                    .post('/api/auth/forgetPassword')
                    .send({
                        'email': 'tester@gmail.com',
                    })

                res.should.have.status(201);

                const updatedUser = await this.User.findOne({ email: "tester@gmail.com" })
                expect(updatedUser.password).to.not.equal("passwordHash")

                sendNewPasswordEmail.restore();
                sinon.assert.calledOnce(sendNewPasswordEmail);


            });

            it('should send error 401 if user not found', async () => {
                const res = await this.chai.request(this.app)
                    .post('/api/auth/forgetPassword')
                    .send({
                        'email': 'tester@gmail.com',
                    })

                res.should.have.status(401);
            });

            it('should send error 500 if password hash fail', async () => {
                sinon.stub(this.crypto, "hash").rejects('Error when hashing');

                const user = new this.User({
                    email: "tester@gmail.com",
                    password: "passwordHash"
                });

                await user.save();

                const res = await this.chai.request(this.app)
                    .post('/api/auth/forgetPassword')
                    .send({
                        'email': 'tester@gmail.com',
                    })

                res.should.have.status(500);
            });

            it('should send error 500 when an error occured while trying to find the user', async () => {
                sinon.stub(this.User, "findOne").rejects('Error when trying to find');

                const res = await this.chai.request(this.app)
                    .post('/api/auth/forgetPassword')
                    .send({
                        'email': 'tester@gmail.com',
                    })

                res.should.have.status(500);
            });

            it('should send error 500 when an error while trying to update the user', async () => {
                sinon.stub(this.User, "findOneAndUpdate").rejects('Error when trying to find');

                const user = new this.User({
                    email: "tester@gmail.com",
                    password: "passwordHash"
                });

                await user.save();

                const res = await this.chai.request(this.app)
                    .post('/api/auth/forgetPassword')
                    .send({
                        'email': 'tester@gmail.com',
                    })

                res.should.have.status(500);
            });
        });
    }
}

new AuthTest().run();

