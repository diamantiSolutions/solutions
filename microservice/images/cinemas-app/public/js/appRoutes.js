angular.module('appRoutes', []).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {

        $routeProvider

                // home page
               /* .when('/', {
                    templateUrl: 'views/login.html',
                    controller: 'CinemaController'
                })
                .when('/logout', {
                    templateUrl: 'views/login.html',
                    controller: 'CinemaController'
                })*/
                .when('/', {
                    templateUrl: 'views/home.html',
                    controller: 'MovController'
                })
                .when('/cinema/:movieId', {
                    templateUrl: 'views/cinemaHall.html',
                    controller: 'CinemaController'
                })
                .when('/cinemas/:cinemaId', {
                    templateUrl: 'views/movieHall.html',
                    controller: 'CinemaController'
                })
                .when('/booking/:movieId', {
                    templateUrl: 'views/booking.html',
                    controller: 'BookingController'
                })
               /* .when('/scale', {
                    templateUrl: 'views/scale.html',
                    controller: 'ScaleController'
                }) */



        $locationProvider.html5Mode(true);

    }]);
