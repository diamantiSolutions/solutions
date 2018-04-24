angular.module('BookingCtrl', []).controller('BookingController', function ($rootScope, $scope, $http, $location, $routeParams) {


    $scope.movieId=$routeParams.movieId;
    
    $scope.paidFlag = 0;


    $scope.inputNameF="arvind";
    $scope.inputNameL="gupta";
    email: 'agupta@diamanti.com';
    $scope.inputCC= "4242424242424242";
    $scope.inputCVC="123";
    $scope.selectCCM="2";
    $scope.selectCCY="2020";



    $scope.cinemaShow = function() {
        $http({
            method: 'GET',
            url: 'movie?movId='+$scope.movieId,
        }).then(function(response) {
            $scope.movieData = response.data;

        });
    }

    

    
	$scope.bookingTicket = function() {
		$http({
	        method: 'GET',
	        url: 'bookingData',
	        }).then(function(response) {
	            $scope.bookData = response.data;
	            //$scope.thFlag = 1;
	            
	            //console.log($scope.citiesData);
	    });
    }



    $scope.payNow  = function() {

	const now = new Date()
	now.setDate(now.getDate() + 1)
	
	var user = {
	    name: $scope.inputNameF,
	    lastName: $scope.inputNameL,
	    email: 'agupta@diamanti.com',
	    creditCard: {
		number: $scope.inputCC,
		cvc: $scope.inputCVC,
		exp_month: $scope.selectCCM,
		exp_year: $scope.selectCCY,
	    },
	    membership: '7777888899990000'
	}
	
	var booking = {
	    city: 'Morelia',
	    cinema: 'Plaza Morelia',
	    movie: {
		title: 'Assasins Creed',
		format: 'IMAX'
	    },
	    schedule: now.toString(),
	    cinemaRoom: 7,
	    seats: ['45'],
	    totalAmount: 10
	}
	
	
		$http({
	            method: 'POST',
	            url: '/booking',
		    data: {
			user: user,
			booking: booking
		    }
	        }).then(function(response) {//success callback
	            $scope.paidData = response.data;
	            $scope.paidFlag = 1;
		},function(response) { //error call back
	            $scope.paidData = response.data;
	            $scope.paidFlag = 2;
		});
    }
    

    
    
});
