angular.module('ScaleCtrl', []).controller('ScaleController', function ($rootScope, $scope, $http, $location,usSpinnerService) {

    if ($rootScope.loggedIn != 1)
        $location.path('/');

    $scope.initialSh = function () {

        $scope.gridOptions = {
            columnDefs: [
                {field: 'name', displayName: 'Service Name'},
                {field: 'currentScale', displayName: 'Current Scale'},
                {
                    field:'fld1',
                    displayName: 'New',
                    cellTemplate: '<input type="text" ng-model="row.entity.fld1">'
                },
                {
                    name: 'edit',
                    displayName: 'Edit',
                    cellTemplate: '<button id="editBtn" type="button" class="btn-warning" ng-click="grid.appScope.edit(row.entity)" >Scale</button> '
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
        console.log(row);
        usSpinnerService.spin('spinner-1');
        $http({
            method: "POST",
            url: "scaleScript",
            data: {
                name: row.name,
                currentScale: row.currentScale,
                fld1:row.fld1
            }

        }).then(function (response) {
            $scope.shellRes = response.data;

            usSpinnerService.stop('spinner-1');
            var index = $scope.gridOptions.data.indexOf(row.entity);
            $scope.gridOptions.data.splice(index-1, 1);

        });

    }
});