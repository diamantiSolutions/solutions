 var mongoose = require('mongoose'),

 Cars = mongoose.model('cars');

function getAllCars(req, res, next) {
  Cars.find({})
    .then(function (data) {
      console.log('data');
      res.status(200)
        .json({
          status:'success',
          data: data,
          message: 'Retrieved ALL cars'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function getSingleCar(req, res, next) {
   Cars.findById(req.params.id)
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved ONE car'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function createCar(req, res, next) {
  var new_car = new Cars(req.body);
  new_car.save()
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Inserted one car'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function updateCar(req, res, next) {
  Cars.findByIdAndUpdate(req.params.id, req.body)
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Updated car'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function removeCar(req, res, next) {
 
  Cars.remove({_id: req.params.id})
    .then(function (result) {
      /* jshint ignore:start */
      res.status(200)
        .json({
          status: 'success',
          message: `Removed the car`
        });
      /* jshint ignore:end */
    })
    .catch(function (err) {
      return next(err);
    });
}


module.exports = {
  getAllCars: getAllCars,
  getSingleCar: getSingleCar,
  createCar: createCar,
  updateCar: updateCar,
  removeCar: removeCar
};
