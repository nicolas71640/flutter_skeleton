const bcrypt = require("bcrypt");

class Crypto {
    hash(data, rounds) {
        return bcrypt.hash(data, rounds);
    }

    compare(string1, string2) {
        return bcrypt.compare(string1, string2)
    }
}


module.exports = Crypto;
