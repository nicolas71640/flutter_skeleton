let Thing = require('../../app/models/Thing');
let chai = require('chai');
let chaiHttp = require('chai-http');
let app = require('../../app/app');
let should = chai.should();
let User = require('../../app/models/User');
const {testHelper} = require('./test_helper');
const { login } = require("../../app/controllers/user");
chai.use(chaiHttp);

testHelper.setup();

//Our parent block
describe('Thing', () => {
  beforeEach((done) => { //Before each test we empty the database
    Thing.remove({}, (err) => {
      done();
    });

  });

  beforeEach((done) => { //Before each test we empty the database
    User.remove({}, (err) => {
      done();
    });
  });


  /*
    * Test the /GET route
    */
  describe('/GET stuff', () => {
    it('it should GET all the things', async () => {
      token = await testHelper.login();
      chai.request(app)
        .get('/api/stuff')
        .set('authorization', 'bearer ' + token)
        .end((err, res) => {
          res.should.have.status(200);
          res.body.should.be.a('array');
          res.body.length.should.be.eql(0);
        });
    });
  });

});
