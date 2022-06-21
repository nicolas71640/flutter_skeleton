let chai = require('chai');
let chaiHttp = require('chai-http');
let app = require('../../app/app');

async function login() {
    res = await chai.request(app)
        .post('/api/auth/signup')
        .send({
            'email': 'tester@gmail.com',
            'password': 'tester'
        });

    res.should.have.status(201);

    // follow up with login
    res = await chai.request(app)
        .post('/api/auth/login')
        .send({
            'email': 'tester@gmail.com',
            'password': 'tester'
        });

    res.body.should.have.property('accessToken');

    return Promise.resolve(res.body.accessToken);
}

exports.login = login;