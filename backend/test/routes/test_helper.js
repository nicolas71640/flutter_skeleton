const { setup, container } = require('../../app/di-setup');

class TestHelper {
    constructor() {
        this.login = this.login.bind(this);
        //this.setup = this.setup.bind(this);

        let chaiHttp = require('chai-http');
        this.chai = require('chai');
        this.should = this.chai.should();
        this.chai.use(chaiHttp);

        setup();
        this.setup();
        this.launch();
    }

    clearStub(stub) {
        try {
            stub.restore();
        } catch (error) { }
    }

    register(nameAndRegistrationPair) {
        container.register(nameAndRegistrationPair)
    }

    setup() {

    }

    launch() {
        let Server = require('../../app/server');
        this.server = new Server("3000");
        this.app = this.server.app;
    }

    async login() {
        let res = await this.chai.request(this.server.app)
            .post('/api/auth/signup')
            .send({
                'email': 'tester@gmail.com',
                'password': 'tester'
            });

        res.should.have.status(201);

        // follow up with login
        res = await this.chai.request(this.server.app)
            .post('/api/auth/login')
            .send({
                'email': 'tester@gmail.com',
                'password': 'tester'
            });

        res.body.should.have.property('accessToken');
        res.body.should.have.property('refreshToken');


        return Promise.resolve([res.body.accessToken, res.body.refreshToken]);
    }
}

module.exports = TestHelper;