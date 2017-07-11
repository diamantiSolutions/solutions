var mongoose = require('mongoose');
var Schema = mongoose.Schema;


var CarsSchema = new Schema({
  model: {
    type: String,
    Required: 'Kindly enter the model of car'
  },
  year: {
    type: Number,
    
  },
  color: {
    type: String
  },
  make: {
    type: String
  },
  
});

module.exports = mongoose.model('cars', CarsSchema);
