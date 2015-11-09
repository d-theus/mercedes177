@orders = angular.module('orders', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'cart'])

#= require orders_constants

OrdersCtrl = ($scope, $resource, $location, $modal) ->
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

OrdersAdminCtrl = ($scope, $resource) ->
  Order = $resource('/orders.json')

  $scope.init = ->
    $scope.orders = Order.query ''

  $scope.init()

OrderEditCtrl = ($scope, $resource) ->

@orders.controller 'OrdersCtrl', ['$scope', '$resource', '$location', '$modal', OrdersCtrl]
@orders.controller 'OrdersAdminCtrl', ['$scope', '$resource', OrdersAdminCtrl]
@orders.controller 'OrderEditCtrl', ['$scope', '$resource', OrderEditCtrl]
