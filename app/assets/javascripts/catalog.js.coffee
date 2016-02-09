@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'category', 'item', 'search', 'cart'])

CatalogCtrl = ($scope, $rootScope, $location, $route)->
  $scope.history = []
  $scope.init = ->
    $scope.$on 'category:tochange', (_, id)->
      console.log id
      console.log "category:tochange #{JSON.stringify id}"
      $location.search('cat', Number(id) )
      $scope.clearItem()
      $scope.$emit 'category:change', id
      $scope._update()
    $scope.$on 'item:tochange', (_, id)->
      console.log "item:tochange #{JSON.stringify id}"
      $location.search('item', Number(id) )
      $scope.$emit 'item:change', id
      $scope._update()
    
    $scope._update()

    $scope.$on 'category_controller:ready', (e)->
      console.log 'category_controller:ready'
      $scope.selectedCategory && $scope.$emit('category:change',  $scope.selectedCategory)

    $scope.$on 'item_controller:ready', (e)->
      console.log 'item_controller:ready'
      $scope.selectedItem     && $scope.$emit('item:change', $scope.selectedItem)

  $scope.clearItem = ->
    $location.search('item', null)
    $scope._update()
    $scope.$emit 'item:change'

  $scope._update = ->
    $scope.selectedItem = $location.search().item
    $scope.selectedCategory = $location.search().cat

  $scope.init()

@catalog.controller 'CatalogCtrl', ['$scope', '$rootScope', '$location', CatalogCtrl]


