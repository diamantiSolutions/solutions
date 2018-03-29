angular.module('HomeCtrl', []).controller('HomeController', function ($rootScope,$scope, $http,$location, usSpinnerService) {

    //$scope.tagline = 'Nothing beats a pocket protector!';

    $scope.shellRes='';
    $scope.selectType='';
    $scope.inputCost="diamanti-sales";
    //$scope.selectType="PostgresSQL";
    $scope.selectStorage="300";
    $scope.selectMirroring="1";
    $scope.selectNetwork="default";
    $scope.selectNetPerfTier="high";
    $scope.selectStoragePerfTier="high";
    $scope.inputsapassword="P455word1"
    $scope.inputpgmasterpassword="password";
    $scope.inputpguser="pgbench";
    $scope.inputpguserpassword="password";
    $scope.inputpgdb="pgbench";
    $scope.inputpgrootpassword="password";
    
    if($rootScope.loggedIn==0)
        $location.path('/');
    $scope.logout = function () {

        console.log('called');
        $rootScope.loggedIn=0;
        $location.path('/');
    }
    $scope.CreateDb = function () {
	
        usSpinnerService.spin('spinner-1');
        $scope.shellRes="Please wait while we cook a database for you...";
        $http({
            method: 'POST',
            url: 'submitForm',
            data: {
                name: this.inputName,
                dbType: this.selectType,
                replication: this.selectReplication,
                storage: this.selectStorage,
                mirroring: this.selectMirroring,
		network: this.selectNetwork,
		netPerfTier: this.selectNetPerfTier,
		storagePerfTier: this.selectStoragePerfTier,
		sapassword: this.inputsapassword,
		pgmasterpassword: this.inputpgmasterpassword,
		pguser: this.inputpguser,
		pguserpassword: this.inputpguserpassword,
		pgdb: this.inputpgdb,
		pgrootpassword: this.inputpgrootpassword
            }
            // headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).then(function(response) {
            usSpinnerService.stop('spinner-1');
            $scope.shellRes=response.data;
        });
    }

    
    $scope.setDb = function(val){
        $scope.selectType=val;
	if( $scope.selectType=="MsSQL")
	    $scope.selectReplication="1";
	else
	    $scope.selectReplication="3";
    }


});
