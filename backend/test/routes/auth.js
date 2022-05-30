let mongoose = require("mongoose");
let User = require('../../app/models/User');

//Require the dev-dependencies
let chai = require('chai');
let chaiHttp = require('chai-http');
let app = require('../../app/app');
let should = chai.should();



chai.use(chaiHttp);



describe('SignUp', function () {

    beforeEach((done) => { 
        User.remove({}, (err) => { 
             done();           
          });        
      });

    it('should Register user and then login', function (done) {
        chai.request(app)
            .post('/api/auth/signup')
            .send({
                'email': 'tester@gmail.com',
                'password': 'tester'
            })
            .end((err, res) => { 
                res.should.have.status(201);

                // follow up with login
                chai.request(app)
                    .post('/api/auth/login')
                    .send({
                        'email': 'tester@gmail.com',
                        'password': 'tester'
                    })
                    .end((err, res) => {
                        res.body.should.have.property('token');
                        var token = res.body.token;
                        done();
                    });
            })
    })

    it('should fail to register user when a user already exists', function (done) {
        chai.request(app)
            .post('/api/auth/signup')
            .send({
                'email': 'tester@gmail.com',
                'password': 'tester'
            }) 
            .end((err, res) => { 
                res.should.have.status(201);

                chai.request(app)
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
})