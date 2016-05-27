@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'category', 'item', 'search', 'cart'])

CatalogCtrl = ($scope, $rootScope, $location, $route)->
  $scope.history = []
  $scope.showContainer = false
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
    $scope.$on 'body:tochange', (_, body)->
      $location.search('body', body)
      $scope.$emit 'body:change', body
      $scope._update()
    $scope.$on 'available:tochange', (_, available)->
      $location.search('available', available)
      $scope.$emit 'available:change', available
      $scope._update()

    $rootScope.$on '$locationChangeSuccess', ->
      $scope._update()
    
    $scope._update()

    $scope.$on 'category_controller:ready', (e)->
      console.log 'categories_controller:ready'
      $scope.selectedCategory && $scope.$emit('category:change',  $scope.selectedCategory)
      $scope.selectedBody && $scope.$emit('body:change',  $scope.selectedBody)
      $scope.selectedAvailable? && $scope.$emit('available:change',  $scope.selectedAvailable)

    $scope.$on 'item_controller:ready', (e)->
      console.log 'item_controller:ready'
      $scope.selectedItem     && $scope.$emit('item:change', $scope.selectedItem)

  $scope.clearItem = ->
    $location.search('item', null)
    $scope._update()
    $scope.$emit 'item:change', null

  $scope.clearCategory = ->
    $location.search('cat', null)
    $scope._update()
    $scope.$emit 'category:change', null

  $scope.setBody = (body)->
    $location.search('body', body)
    $scope._update()
    $scope.$emit 'body:change', body

  $scope.setAvailable = (available)->
    $location.search('available', available)
    $scope._update()
    $scope.$emit 'available:change', available

  $scope.clearFilter = ->
    $location.search('body', null)
    $location.search('count', null)
    $scope._update()
    $scope.$emit 'body:change', null
    $scope.$emit 'available:change', null

  $scope.clear = ->
    $location.search('cat', null)
    $location.search('item', null)
    $location.search('body', null)
    $location.search('available', null)
    $scope._update()
    $scope.$emit 'category:change'
    $scope.$emit 'item:change'
    $scope.$emit 'available:change'
    $scope.$emit 'body:change'

  $scope._update = ->
    $scope.selectedItem = $location.search().item
    $scope.selectedCategory = $location.search().cat
    $scope.selectedBody = $location.search().body
    $scope.selectedAvailable = $location.search().available
    $scope.showContainer = $scope.selectedCategory || $scope.selectedItem || $scope.selectedBody

  $scope.init()

@catalog.controller 'CatalogCtrl', ['$scope', '$rootScope', '$location', CatalogCtrl]


