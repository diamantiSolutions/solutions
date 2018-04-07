angular.module('CinemaCtrl', ['CinemaCtrl.directives']).controller('CinemaController', function($rootScope, $scope, $http, $location, $routeParams) {

    //$scope.tagline = 'Nothing beats a pocket protector!';

    $scope.drpCountry = "588ac0293a02da6d15d0b5c4";
    $scope.selectType = '';
    $scope.btnSubmit = false;
    console.log("finding theater for movie id " +$routeParams.movieId);

    $scope.selection = [];
    $scope.state = {};
    $scope.city = {};
    $scope.movieId=$routeParams.movieId;

    var allCountries = [{
            "Id": "588ac0293a02da6d15d0b5c4",
            "CountryName": "USA"
        }, {
            "Id": "588da6d15d0ac0293a02b5c4",
            "CountryName": "Australia"
        }];

    $scope.cinemaShow = function() {
        $http({
            method: 'GET',
            url: 'movie?movId='+$scope.movieId,
        }).then(function(response) {
            $scope.movieData = response.data;

        });

        $http({
            method: 'GET',
            url: 'theatersData',
        }).then(function(response) {
            $scope.theaterData = response.data;

        });

        $http({
            method: 'GET',
            url: 'statesData',
        }).then(function(response) {
            $scope.statesData = response.data;
            $scope.states = $scope.statesData;
        });

        //$scope.statesData = "";
	/*
        $http({
            method: 'GET',
            url: 'citiesData',
        }).then(function(response) {
            $scope.citiesData = response.data;
            //console.log($scope.citiesData);
        });
	*/

    }

    $scope.cities = [];
    $scope.selectedSte = function(staeId) {
/*
        $scope.seletedStae = staeId;
        $scope.cities = $scope.citiesData.filter(function(c) {
            return c.state_id == $scope.seletedStae;
            console.log("filter call");
        });
        $scope.city = {};
        console.log($scope.cities);
*/


        $http({
            method: 'GET',
            url: 'citiesData?stateId=' + staeId,
        }).then(function(response) {
            $scope.cities = response.data;
            //console.log($scope.citiesData);
        });


	
    }

    $scope.thFlag = 0;
    $scope.selectedCity = function(cityId) {
	/*
        $http({
            method: 'GET',
            url: 'theater?cityId=' + cityId,
        }).then(function(response) {
            $scope.thsData = response.data;
            $scope.thFlag = 1;
            //console.log($scope.citiesData);
        });
	*/
	
        $http({
            method: 'GET',
            url: 'theatersData?cityId=' + cityId+'&movieId='+$scope.movieId,
        }).then(function(response) {
            $scope.thsData = response.data;
            $scope.thFlag = 1;
            //console.log($scope.citiesData);
        });

    }

    $scope.showHall = function(id) {
        console.log(id);
        $location.path('cinemas/' + id);
    }

    $scope.cinemasFlag = 0;
    $scope.cinemasList = function(Id) {
        $http({
            method: 'GET',
            url: 'cinemas?cinemaId=' + $routeParams.cinemaId,
        }).then(function(response) {
            $scope.cinemasData = response.data;
            $scope.cinemasFlag = 1;
            //console.log($scope.citiesData);
        });

    }
    $scope.bookFlag = 0;
    $scope.scheduleFlag = 0;
    $scope.movFlag = 0;

    $scope.bookNow = function(movId) {
        $scope.movieId = movId;
        $scope.bookFlag = 1;
        $scope.movFlag = 1;

    }
    $scope.Seats = function(mId, time) {
        $scope.scheduleFlag = 1;
        $scope.movieId = mId;
        $scope.movieTime = time;
        $scope.selection = [];
    }




    $scope.bookTicket = function() { /*time, movieId, citeId, format*/
        $location.path('booking/'+ $scope.movieId);        
    }

});

var directives = angular.module('CinemaCtrl.directives', []);

directives.directive('checkSeats', function() {
    return{
        restrict: 'A',
        link: function($scope, elem, atrrib) {
            elem.bind('click', function() {
                var bookSeat = $scope.selection.indexOf($scope.seats);
                if (elem[0].checked) {
                    if (bookSeat === -1)
                        $scope.selection.push($scope.seats);
                } else {
                    if (bookSeat !== -1)
                        $scope.selection.splice(bookSeat, 1);
                }
                $scope.selection.sort(function(a, b) {
                    return a - b
                });
                $scope.$apply($scope.selection);
                return $scope.selection;
            })
        }
    };
});
