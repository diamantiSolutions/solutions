angular.module('MainCtrl', []).controller('MainController', function($scope , $location) {

	$scope.login = function () {
		   
		    if(this.inputUser == "admin" && this.inputPassword == "admin"){
		    	console.log(this.inputUser);
		    	console.log(this.inputPassword);

		    	$location.path('home');

		    }
		    	else{
		    		$scope.err ="user name and password are not match";
		    	}
		    
		}

});