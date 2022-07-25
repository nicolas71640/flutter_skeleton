const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const userSchema = mongoose.Schema({
    email: { type: String, required: true, unique: true },
    userId: { type: String },
    password: { type: String, required: false},
});

userSchema.plugin(uniqueValidator);

module.exports = mongoose.model("User",userSchema);