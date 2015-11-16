@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'item', 'search', 'cart'])

CategoriesCtrl = ($scope, $rootScope, $resource, $location, $modal) ->
  $scope.editing = false

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})

  $scope.updateLocation = (cat)->
    $location.search('cat', if cat.current then cat.id else null )

  $scope.setCategory = ->
    cid = Number($location.search().cat)
    for cat in $scope.categories
      cat.current = false
      if cat.id == cid
        cat.current = true

  $scope.setItem = (id)->
    $location.search('item', id)
    $scope.$emit 'item:changed'

  $scope.openNewDialog = ->
    $scope.newCategory = new Category
    m = $modal.open(
      scope: $scope
      templateUrl: '/templates/categories/new_modal'
    )

    m.result.then ->
      $scope.newCategory.$save (created)->
        $scope.categories.unshift(created)
      , (e)->
        msgs = []
        for field, msg of e.data.errors
          msgs.push "#{field}: #{msg}"
        alert "ОШИБКА!" + msgs.join('/n')
    , ->
      delete $scope.newCategory

  $scope.delete = (cat)->
    return unless confirm "Действительно удалить категорию\n'#{cat.name}'"
    $scope.categories.splice($scope.categories.indexOf(cat), 1)
    cat.$remove()

  $scope.init = ->
    $rootScope.$on "category:changed", $scope.setCategory

    categoriesQuery = Category.query ''
    categoriesQuery.$promise.then (categories)->
      $scope.categories = categories
      $scope.setCategory()

    allItemsQuery = Item.query ''

    allItemsQuery.$promise.then (items)->
      $scope.allItems = items

    allItemsQuery.$promise.then (items)->
      $scope.bodies =
        items.reduce (ary,v)->
          body = v['body']
          ary.push(body) if body && ary.indexOf(body) < 0
          ary
        , []

    $scope.filters = { count: '!0', body: null }

  $scope.init()


NavigationCtrl = ($scope, $rootScope, $location)->
  $scope.history = []
  $scope.init = ->
    $rootScope.$on 'location:changed', (to)->
      $scope.history.push($location.search(to))

    $rootScope.$on 'location:back', ->
      $location.search($scope.history.pop() || "")

  $scope.clear = ->
    $scope.history.splice(0, $scope.history.length)
    $location.search('item', null)
    $location.search('cat', null)
    $scope.$emit 'category:changed'
    $scope.$emit 'item:changed'

  $scope.init()

@catalog.controller 'CategoriesCtrl', ['$scope', '$rootScope', '$resource', '$location', '$modal', CategoriesCtrl]
@catalog.controller 'NavigationCtrl', ['$scope', '$rootScope', '$location', NavigationCtrl]


