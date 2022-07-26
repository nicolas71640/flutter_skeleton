const { setup, container } = require('../../app/di-setup');





class TestHelper {
    constructor() {
        this.login = this.login.bind(this);
        this.setup = this.setup.bind(this);

        this.chai = require('chai');
    }

    setup(nameAndRegistrationPair) {
        setup();
        if (nameAndRegistrationPair != null) {
            container.register(nameAndRegistrationPair)
        }
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

        return Promise.resolve(res.body.accessToken);
    }
}

const testHelper = new TestHelper();



module.exports = { testHelper };