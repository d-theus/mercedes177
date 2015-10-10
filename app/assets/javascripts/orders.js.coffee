@orders = angular.module('orders', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'cart'])

@orders.controller 'OrdersController', ($scope, $resource, $location, $modal) ->

