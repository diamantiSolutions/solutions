angular.module('MainCtrl', []).controller('MainController', function($rootScope,$scope , $location) {

	if($rootScope.loggedIn==1){
        $location.path('home');
	}

	$scope.login = function () {
		   
		    if(this.inputUser == "admin" && this.inputPassword == "admin"){
		    	console.log(this.inputUser);
		    	console.log(this.inputPassword);

		    	$location.path('home');
		    	$rootScope.loggedIn=1;

		    }
		    	else{
		    		$scope.err ="user name and password are not match";
		    	}
		    
		}


});