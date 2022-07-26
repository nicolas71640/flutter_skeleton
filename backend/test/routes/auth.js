//Require the dev-dependencies
const TestHelper = require('./test_helper');
const sinon = require("sinon");
const awilix = require('awilix');

//Other
const { OAuth2Client } = require('google-auth-library');
const { LoginTicket } = require('google-auth-library');
const Crypto = require('../../app/controllers/utils/crypto');
let User = require('../../app/models/User');


class AuthTest extends TestHelper {
    setup() {
        this.client = new OAuth2Client("CLIENT_ID");
        this.ticket = new LoginTicket();
        this.crypto = new Crypto();

        this.register({
            oauthClient: awilix.asValue(this.client),
            crypto: awilix.asValue(this.crypto)
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
        })
    }
}

new AuthTest().run();

