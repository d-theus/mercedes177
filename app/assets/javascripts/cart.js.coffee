@cart = angular.module('cart', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap'])

CartCtrl = ($scope, $resource, $modal, $cookies) ->
  class Position
    constructor: (item, @count) ->
      @id = item.id
      @name = item.name
      @serial = item.serial
      @price = item.price
    add: ->
      @count += 1
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
      $scope.positions = (new Position({id: p.id, name: p.name, serial: p.serial, price: p.price}, p.count) for p in pos)
    else
      $scope.positions = []
      $scope.updateCookies()
  
  $scope.updateCookies = ->
    $cookies.putObject('cart-positions', $scope.positions, path: '/')

  $scope.put = (item, count = 1)->
    dupl = $scope.positions.filter((p) -> p.id == item.id)[0]
    if dupl
      dupl.add()
    else
      $scope.positions.push new Position(item, count)
    $scope.updateCookies()

  $scope.unput = (pos)->
    el = $scope.positions.filter((p) -> p.id == pos.id)[0]
    el.subtract()
    $scope.updateCookies()

  $scope.clear = ->
    $scope.positions.splice(0, $scope.positions.length)
    $scope.updateCookies()

  $scope.remove = (pos)->
    $scope.positions.splice($scope.positions.indexOf(pos),1)
    $scope.updateCookies()

  $scope.summarize = ->
    $scope.positions.reduce ((acc,e) -> acc + (e.price) * e.count), 0

  $scope.getPositions()

@cart.controller 'CartCtrl', ['$scope', '$resource', '$modal', '$cookies', CartCtrl]
