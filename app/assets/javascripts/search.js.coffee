@search = angular.module('search', ['ngResource', 'ngAnimate', 'ui.bootstrap'])
@search.controller 'SearchCtrl', ($scope, $resource) ->
  Item = $resource('/items/:id')
  
  $scope.getItems = ->
    unless $scope.items?
      $scope.fullItems = Item.query '', ->
        $scope.items = $scope.fullItems
          .map (e)-> {id: e.id, name: e.name, serial: e.serial}