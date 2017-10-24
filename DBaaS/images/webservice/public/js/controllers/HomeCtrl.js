angular.module('HomeCtrl', []).controller('HomeController', function ($scope, $http) {

    //$scope.tagline = 'Nothing beats a pocket protector!';

    $scope.shellRes='';
    $scope.CreateDb = function () {

        $http({
            method: 'POST',
            url: 'submitForm',
            data: {
                cost: this.inputCost,
                name: this.inputName,
                dbType: this.selectType,
                replication: this.selectReplication,
                storage: this.selectStorage,
                mirroring: this.selectMirroring,
                performance: this.selectPerformance
            }
            // headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).then(function(response) {
            $scope.shellRes=response.data;
        });
    }

});