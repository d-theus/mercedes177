@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'item', 'search', 'cart'])
@catalog.controller 'CategoriesCtrl', ($scope, $resource, $location, $modal) ->
  $scope.editing = false

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})

  $scope.categories = Category.query '', ->
    if (cid = Number($location.search().cat))
      for cat in $scope.categories
        if cat.id == cid
          cat.current = true

  $scope.allItems = Item.query '', ->
    if (iid = Number($location.search().item))
      for item in $scope.items
        if item.id == iid
          $scope.setItem(item)

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

  $scope.showAll = ->
    $scope.items = $scope.allItems

  $scope.showAvailable = ->
    $scope.items = $scope.allItems.filter (item)-> item.count > 0

  $scope.showAll()
