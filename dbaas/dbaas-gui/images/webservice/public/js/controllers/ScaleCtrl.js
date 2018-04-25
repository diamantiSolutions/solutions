angular.module('ScaleCtrl', []).controller('ScaleController', function ($rootScope, $scope, $http, $location,usSpinnerService) {

    if ($rootScope.loggedIn != 1)
        $location.path('/');

    $scope.initialSh = function () {

        $scope.gridOptions = {
            columnDefs: [
                {field: 'name', displayName: 'Service Name'},
                {field: 'currentScale', displayName: 'Current Scale'},
                {
                    name: 'edit',
                    displayName: 'Update',
                    cellTemplate: '<button id="editBtn" type="button" class="btn-warning" ng-click="grid.appScope.edit(row.entity)" >Scale</button> <button id="deleteBtn" type="button" class="btn-danger" ng-click="grid.appScope.delete(row.entity)" >Delete</button> '
                }
            ]
        };


        $http({
            method: 'POST',
            url: 'initialShellData',
        }).then(function (response) {

            $scope.gridOptions.data = response.data.services;
        });

    }
    $scope.edit = function (row) {
        usSpinnerService.spin('spinner-1');
        $http({
            method: "POST",
            url: "scaleScript",
            data: {
                name: row.name,
                newScale: currentScale
            }

        }).then(function (response) {
            $scope.shellRes = response.data;

            usSpinnerService.stop('spinner-1');
	    
            $http({
		method: 'POST',
		url: 'initialShellData',
            }).then(function (response) {
		$scope.gridOptions.data = response.data.services;
            });
	    
        });

    }
    $scope.delete = function (row) {
        usSpinnerService.spin('spinner-1');
        $http({
            method: "POST",
            url: "deleteScript",
            data: {
                name: row.name,
            }

        }).then(function (response) {
            $scope.shellRes = response.data;
            usSpinnerService.stop('spinner-1');


            $http({
		method: 'POST',
		url: 'initialShellData',
            }).then(function (response) {
		$scope.gridOptions.data = response.data.services;
            });
	    
        });

    }
});
