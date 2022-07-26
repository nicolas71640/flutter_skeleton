let mongoose = require("mongoose");
let User = require('../../app/models/User');
const awilix = require('awilix');
const { testHelper } = require('./test_helper');



//Require the dev-dependencies
let chai = require('chai');
let chaiHttp = require('chai-http');
let should = chai.should();
const sinon = require("sinon");
chai.use(chaiHttp);

//DI
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client("CLIENT_ID");
var stub = sinon.stub(client, "verifyIdToken");
testHelper.setup({
    oauthClient: awilix.asValue(client)
});

class AuthTest{
    run() {
        describe('SignUp', function () {
            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should Register user and then login', function (done) {
                chai.request(testHelper.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(201);

                        // follow up with login
                        chai.request(testHelper.app)
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

            it('should fail to register user when a user already exists', function (done) {
                chai.request(testHelper.app)
                    .post('/api/auth/signup')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.should.have.status(201);

                        chai.request(testHelper.app)
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

        describe('Login', function () {

            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should return error 500 when the user does not exist', function (done) {
                chai.request(testHelper.app)
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

        describe('OAuth', function () {

            beforeEach((done) => {
                User.remove({}, (err) => {
                    done();
                });
            });

            it('should return error 500 when the user does not exist', function (done) {
                chai.request(testHelper.app)
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

