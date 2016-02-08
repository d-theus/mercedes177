@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'category', 'item', 'search', 'cart'])

CatalogCtrl = ($scope, $rootScope, $location, $route)->
  $scope.history = []
  $scope.init = ->
    $rootScope.$on 'category:tochange', (_, id)->
      console.log id
      console.log "category:tochange #{JSON.stringify id}"
      $location.search('cat', Number(id) )
      $scope.clearItem()
      $scope.$emit 'category:change', id
      $scope._update()
    $rootScope.$on 'item:tochange', (_, id)->
      console.log "item:tochange #{JSON.stringify id}"
      $location.search('item', Number(id) )
      $scope.$emit 'item:change', id
      $scope._update()
    
    $scope._update()

    $rootScope.$on 'category_controller:ready', ->
      $scope.selectedCategory && $scope.$emit('category:change',  $scope.selectedCategory)
    $rootScope.$on 'item_controller:ready', ->
      $scope.selectedItem     && $scope.$emit('item:change', $scope.selectedItem)

  $scope.clear = ->
    $scope._withLockedHistory ->
      $scope.history.splice(0, $scope.history.length)
      $location.search('item', null)
      $location.search('cat', null)
      $scope.$emit 'category:tochange'
      $scope.$emit 'item:tochange'

  $scope.back = ->
    $scope._withLockedHistory ->
      id = $scope.history.pop()
      if id
        $location.search('item', id)
        $scope.$emit 'item:tochange'

  $scope.clearItem = ->
    $location.search('item', null)
    $scope._update()
    $scope.$emit 'item:change'
    $scope.$emit 'category:change', $scope.selectedCategory

  $scope._writeHistory = (e, oldId, newId)->
    $scope._withLockedHistory ->
      id = oldId || $location.search().item || null
      if id && (Number($scope.history[$scope.history.length - 1]) != Number(id))
        $scope.history.push id

  $scope._withLockedHistory = (fn)->
    return if $scope.historyLocked
    $scope.historyLocked = true
    fn.call()
    $scope.historyLocked = false

  $scope.maximize = ->
    $scope.$emit 'catalog:maximize'

  $scope._update = ->
    $scope.selectedItem = $location.search().item
    $scope.selectedCategory = $location.search().cat

  $scope.init()

@catalog.controller 'CatalogCtrl', ['$scope', '$rootScope', '$location', CatalogCtrl]


