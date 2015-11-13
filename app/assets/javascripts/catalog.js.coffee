@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'item', 'search', 'cart'])

CategoriesCtrl = ($scope, $resource, $location, $modal) ->
  $scope.editing = false

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})

  $scope.updateLocation = (cat)->
    $location.search('cat', if cat.current then cat.id else null )

  $scope.setItem = (item)->
    $('#catalog_container').scope().setItem(item)
    $location.search('item', item.id)

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
    $scope.categories = Category.query '', ->
      if (cid = Number($location.search().cat))
        for cat in $scope.categories
          if cat.id == cid
            cat.current = true

    allItemsQuery = Item.query ''

    allItemsQuery.$promise.then (items)->
      $scope.allItems = items
      if (iid = Number($location.search().item))
        for item in $scope.allItems
          if item.id == iid
            $scope.setItem(item)

    $scope.filters = { count: '!0' }

  $scope.init()


@catalog.controller 'CategoriesCtrl', ['$scope', '$resource', '$location', '$modal', CategoriesCtrl]
