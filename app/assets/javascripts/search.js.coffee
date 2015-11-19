@search = angular.module('search', ['ngResource', 'ngAnimate', 'ui.bootstrap'])

SearchCtrl = ($scope, $resource, $q, $filter, $modal, $location) ->
  Item = $resource('/items/:id')
  
  $scope.getItems = ->
    unless $scope.items?
      query = (Item.query '').$promise
      query
        .then (result)->
          $scope.fullItems = result
          $q.resolve result
        .then (fullItems)->
          $scope.items = fullItems.map (e)->
            id: e.id
            name: e.name
            serial: e.serial
            line: "#{e.name} [#{e.serial}]"

  $scope.showResults = ->
    $scope.results = $filter('filter')($scope.items, {line: $scope.query})

    $scope.modal = $modal.open(
      scope: $scope,
      size: 'md',
      templateUrl: '/templates/shared/search_results')

  $scope.viewItem = (id)->
    $location.search('item', id)
    $scope.$emit 'item:changed'
    $scope.modal.close() if $scope.modal


@search.controller 'SearchCtrl', ['$scope', '$resource', '$q', '$filter', '$modal', '$location', SearchCtrl]
