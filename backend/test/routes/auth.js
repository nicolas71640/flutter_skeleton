//Require the dev-dependencies
const TestHelper = require('./test_helper');
const sinon = require("sinon");
const awilix = require('awilix');

//Other
const { OAuth2Client } = require('google-auth-library');
let User = require('../../app/models/User');


class AuthTest extends TestHelper {
    setup() {
        const client = new OAuth2Client("CLIENT_ID");
        var stub = sinon.stub(client, "verifyIdToken");

        this.register({
            oauthClient: awilix.asValue(client)
        });
    }

    run() {
        describe('SignUp', () => {
            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should Register user and then login', (done) => {
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
        });

        describe('Login', () => {

            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
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
        })

        describe('OAuth', () => {

            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should return error 500 when the user does not exist', (done) => {
                this.chai.request(this.app)
                    .post('/api/auth/oauth')
                    .send({
                        'idToken': 'myIdToken',
                    })
                    .end((err, res) => {
                        res.should.have.status(401);
                        done();
                    });
            });
        })

    }
}

new AuthTest().run();

