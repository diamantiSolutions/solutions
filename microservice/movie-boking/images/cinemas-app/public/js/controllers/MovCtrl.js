angular.module('MovCtrl', []).controller('MovController', function($rootScope, $scope, $location , $http) {

    /*if($rootScope.loggedIn==1){
     $location.path('home');
     }*/

    $scope.initialShow = function () {        
        $http({
            method: 'GET',
            url: 'moviesData',
        }).then(function (response) {
            $scope.moiveData = response.data;
            console.log($scope.moiveData);
        });

        // $http({
        //     method: 'GET',
        //     url: 'theatersData',
        // }).then(function (response) {
        //     $scope.theaterData = response.data;
        //     console.log($scope.theaterData);
        // });

        $http({
            method: 'GET',
            url: 'moviesPremiere',
        }).then(function (response) {
            $scope.moivePremierData = response.data;
            console.log($scope.moivePremierData);
        });


	
    } 

    $scope.movieFlag = 'all';

    $scope.setFlagAll = function(val){
        $scope.movieFlag = val;
    }
    // $scope.setFlagPremier = function(){
    //     $scope.movieFlag = 'premier';
    // }
    

    $scope.bookMyShow = function (movId){
        //console.log(movId);
        $location.path('cinema/' + movId);
    }



});
