@cart = angular.module('cart', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap'])

CartCtrl = ($scope, $rootScope, $resource, $modal, $cookies, $location) ->
  class Position
    constructor: (item, @count) ->
      @id = item.id
      @name = item.name
      @serial = item.serial
      @price = item.price
      @available = item.count || throw 'No items available 0_0'
    add: ->
      @count += 1 if @count < @available
    subtract: ()->
      @count -= 1 if @count > 0

    Position.sample = ->
      [1..20].map (i)->
        new Position(
          {
            id: i
            name: "Товар #{i}"
            serial: "W#{Math.ceil (Math.random() * 10000000)}"
            price: Math.round(Math.random(150*i) * 1000).toPrecision(3)
          },
          Math.ceil(Math.random() * 15 * i) + 1
        )

  $scope.open = ->
    $modal.open(
      scope: $scope
      size: 'lg'
      templateUrl: '/templates/cart/modal'
    )

  $scope.getPositions = ->
    pos = $cookies.getObject('cart-positions')
    if pos
      $scope.positions = (new Position({id: p.id, name: p.name, serial: p.serial, price: p.price, count: p.available}, p.count) for p in pos)
    else
      $scope.positions = []
    $scope.$broadcast 'positions:updated', 'stuff'
  
  $scope.updateCookies = ->
    $cookies.putObject('cart-positions', $scope.positions, path: '/')

  $scope.put = (item, count = 1)->
    dupl = $scope.positions.filter((p) -> p.id == item.id)[0]
    if dupl
      dupl.add()
    else
      $scope.positions.push new Position(item, count)
    $scope.$broadcast 'positions:updated'

  $scope.unput = (pos)->
    el = $scope.positions.filter((p) -> p.id == pos.id)[0]
    el.subtract()
    $scope.$broadcast 'positions:updated'

  $scope.clear = ->
    $scope.positions.splice(0, $scope.positions.length)
    $scope.$broadcast 'positions:updated'

  $scope.remove = (pos)->
    $scope.positions.splice($scope.positions.indexOf(pos),1)
    $scope.$broadcast 'positions:updated'

  $scope.summarize = ->
    $scope.positions.reduce ((acc,e) -> acc + (e.price) * e.count), 0

  $scope.updateCheckoutButton = ->
    $scope.showingCheckoutButton =
      $scope.positions.length && !$location.absUrl().match(/\/orders\/new/)

  $scope.init = ->
    $scope.$on 'positions:updated', $scope.updateCheckoutButton
    $scope.$on 'positions:updated', $scope.updateCookies
    $rootScope.$on 'cart:put', (e,item, count)->
      $scope.put(item, count)
    $rootScope.$on 'cart:put-and-checkout', (e, item, count)->
      $scope.put item, count
      window.location = '/orders/new'
    $scope.getPositions()

  $scope.init()


@cart.controller 'CartCtrl', ['$scope', '$rootScope', '$resource', '$modal', '$cookies', '$location', CartCtrl]
