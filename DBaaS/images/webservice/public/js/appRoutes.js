angular.module('appRoutes', []).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

	$routeProvider

		// home page
		.when('/', {
			templateUrl: 'views/login.html',
			controller: 'MainController'
		})

		.when('/home', {
			templateUrl: 'views/home.html',
			controller: 'HomeController'
		})

		

	$locationProvider.html5Mode(true);

}]);