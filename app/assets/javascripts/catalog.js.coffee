@catalog = angular.module('catalog', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'item', 'search', 'cart'])

CategoriesCtrl = ($scope, $rootScope, $resource, $location, $modal, $q, $window) ->
  $scope.editing = false
  $scope.ready= false
  $scope.maximized = not $location.search().item

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})

  $scope.updateLocation = (cat)->
    $location.search('cat', if cat.current then cat.id else null )
    $scope.$emit 'category:changed'

  $scope.setCategory = ->
    cid = Number($location.search().cat)
    for cat in $scope.categories
      cat.current = false
      if cat.id == cid
        cat.current = true

  $scope.setItem = (id)->
    oldId = $location.search().item
    $location.search('item', id)
    $scope.$emit 'item:tochange', oldId, id

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

  $scope.openEditDialog = (cat)->
    $scope.category = cat
    m = $modal.open(
      scope: $scope
      templateUrl: '/templates/categories/edit_modal'
    )

    m.result.then ->
      Category.update id: $scope.category.id, name: $scope.category.name, ->
        delete $scope.category
      , (e)->
        msgs = []
        for field, msg of e.data.errors
          msgs.push "#{field}: #{msg}"
        alert "ОШИБКА!" + msgs.join('/n')


  $scope.delete = (cat)->
    return unless confirm "Действительно удалить категорию\n'#{cat.name}'"
    $scope.categories.splice($scope.categories.indexOf(cat), 1)
    cat.$remove()

  $scope.toggleMaximized = (value = null)->
    if value != null
      $scope.maximized = value
    else
      $scope.maximized = !$scope.maximized
    $window.scrollTo(0,130)

  $scope.maximize = ->
    $scope.toggleMaximized(true)

  $scope.minimize = ->
    $scope.toggleMaximized(false)

  $scope.init = ->
    $rootScope.$on "category:tochange", $scope.setCategory
    $rootScope.$on "item:tochange", $scope.minimize
    $rootScope.$on "catalog:maximize", $scope.maximize

    categoriesQuery = (Category.query '').$promise
    categoriesQuery.then (categories)->
      $scope.categories = categories
      $scope.setCategory()

    itemsQuery = (Item.query '').$promise

    itemsQuery.then (items)->
      $scope.allItems = items

    itemsQuery.then (items)->
      $scope.bodies =
        items.reduce (ary,v)->
          body = v['body']
          ary.push(body) if body && ary.indexOf(body) < 0
          ary
        , []

    $scope.filters = { count: '!0', body: undefined }
    $q.all([categoriesQuery, itemsQuery])
      .then ->
        $scope.ready = true

  $scope.init()


CatalogCtrl = ($scope, $rootScope, $location, $route)->
  $scope.history = []
  $scope.init = ->
    $rootScope.$on 'item:tochange', $scope._writeHistory

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

  $scope.init()

@catalog.controller 'CategoriesCtrl', ['$scope', '$rootScope', '$resource', '$location', '$modal', '$q', '$window', CategoriesCtrl]
@catalog.controller 'CatalogCtrl', ['$scope', '$rootScope', '$location', CatalogCtrl]


