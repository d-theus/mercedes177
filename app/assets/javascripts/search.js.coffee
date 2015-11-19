@search = angular.module('search', ['ngResource', 'ngAnimate', 'ui.bootstrap'])

SearchCtrl = ($scope, $resource, $q, $filter, $modal, $location) ->
  Item = $resource('/items/:id')
  
  $scope.getItems = ->
    unless $scope.items?
      query = (Item.query '').$promise
      query
        .then (result)->
          $scope.items = result.map (e)->
            e.line = "#{e.name} [#{e.serial}]"
            e
          $q.resolve result

  $scope.showResults = ->
    if !$scope.query || $scope.query == ''
      alert 'Пустой запрос'
      return
    
    $scope.results = $filter('filter')($scope.items, {line: $scope.query})

    $scope.modal = $modal.open(
      scope: $scope,
      size: 'md',
      templateUrl: '/templates/shared/search_results')

  $scope.viewItem = (id)->
    $location.search('item', id)
    $scope.$emit 'item:tochange'
    $scope.modal.close() if $scope.modal


@search.controller 'SearchCtrl', ['$scope', '$resource', '$q', '$filter', '$modal', '$location', SearchCtrl]
