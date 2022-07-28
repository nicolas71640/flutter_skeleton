let Thing = require('../../app/models/Thing');
let User = require('../../app/models/User');
const TestHelper = require('../test_helper');


class StuffTest extends TestHelper {
    run() {
        describe('Thing', () => {
            beforeEach( async () => { //Before each test we empty the database
                await Thing.remove();
                await User.remove();
            });

            /*
              * Test the /GET route
              */
            describe('/GET stuff', () => {
                it('it should GET all the things', async () => {
                    const [accesstoken,] = await this.login();
                    this.chai.request(this.app)
                        .get('/api/stuff')
                        .set('authorization', 'bearer ' + accesstoken)
                        .end((err, res) => {
                            res.should.have.status(200);
                            res.body.should.be.a('array');
                            res.body.length.should.be.eql(0);
                        });
                });

                it('it should return error 401 if accessToken is wrong', async () => {
                    const [,refreshToken] = await this.login();
                    this.chai.request(this.app)
                        .get('/api/stuff')
                        .set('authorization', 'bearer ' + refreshToken)
                        .end((err, res) => {
                            res.should.have.status(401);
                        });
                });
            });

        });
    }
}

new StuffTest().run();

