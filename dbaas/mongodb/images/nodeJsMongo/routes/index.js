module.exports = function(app) {
	var db = require('../queries');
	app.route('/api/cars').get(db.getAllCars);
	app.route('/api/cars/:id').get(db.getSingleCar);
	app.route('/api/cars').post(db.createCar);
	app.route('/api/cars/:id').put(db.updateCar);
	app.route('/api/cars/:id').delete(db.removeCar);
};
