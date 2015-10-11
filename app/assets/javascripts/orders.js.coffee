@orders = angular.module('orders', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'cart'])

@orders.controller 'OrdersCtrl', ($scope, $resource, $location, $modal) ->
  $scope.clearCart = ->
    $scope.cart.clear()

  $scope.calcTotal = ->
    $scope.positions.reduce ((acc,e) -> acc + (e.price) * e.count), 0

  $scope.init = ->
    $scope.cart = angular.element("#cart").scope()
    $scope.positions = $scope.cart.positions

  $scope.isEmpty = ->
    $scope.positions.length == 0

  $scope.init()
