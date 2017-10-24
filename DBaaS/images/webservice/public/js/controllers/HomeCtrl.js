angular.module('HomeCtrl', []).controller('HomeController', function ($rootScope,$scope, $http,$location) {

    //$scope.tagline = 'Nothing beats a pocket protector!';

    $scope.shellRes='';
    $scope.selectType='SQL';
    if($rootScope.loggedIn==0)
        $location.path('/');
    $scope.logout = function () {

        console.log('called');
        $rootScope.loggedIn=0;
        $location.path('/');
    }
    $scope.CreateDb = function () {

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
		pgmasterpassword: this.inputpgmasterpassword,
		pguser: this.inputpguser,
		pguserpassword: this.inputpguserpassword,
		pgdb: this.inputpgdb,
		pgrootpassword: this.inputpgrootpassword
            }
            // headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).then(function(response) {
            $scope.shellRes=response.data;
        });
    }

});
