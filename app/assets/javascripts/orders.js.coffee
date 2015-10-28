@orders = angular.module('orders', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'cart'])

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
  $scope.Statuses = ['Новый', 'Собирается', 'Готов', 'Отправлен', 'Закрыт', 'Отменен']
  $scope.DeliveryMethods = ['Самовывоз', 'Курьер', 'Почта']
  
  $scope.init = ->
    $scope.orders = Order.query ''

  $scope.init()

OrderEditCtrl = ($scope, $resource) ->
  $scope.Statuses = ['Новый', 'Собирается', 'Готов', 'Отправлен', 'Закрыт', 'Отменен']
  $scope.DeliveryMethods = ['Самовывоз', 'Курьер', 'Почта']

@orders.controller 'OrdersCtrl', ['$scope', '$resource', '$location', '$modal', OrdersCtrl]
@orders.controller 'OrdersAdminCtrl', ['$scope', '$resource', OrdersAdminCtrl]
@orders.controller 'OrderEditCtrl', ['$scope', '$resource', OrderEditCtrl]
