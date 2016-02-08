@category = angular.module('category', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap', 'item', 'search', 'cart'])

CategoriesCtrl = ($scope, $rootScope, $resource, $location, $modal, $q, $window) ->
  $scope.editing = false

  $scope.maximized = not $location.search().item

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})
  ItemPhoto = $resource('/items/:item_id/photos/:id', { item_id: '@item_id', id: '@id'}, { query: { isArray: false}})

  $scope.changeCategory = (id)->
    console.log "changeCategory #{JSON.stringify id}"
    $scope.$emit 'category:tochange', id

  $scope.changeItem = (id)->
    console.log "changeItem #{JSON.stringify id}"
    $scope.$emit 'item:tochange', id

  $scope.setCategory = (cid)->
    cid = Number(cid)
    console.log "setCategory #{JSON.stringify cid}"
    return unless cid
    for cat in $scope.categories
      cat.current = false
      if cat.id == cid
        cat.current = true
        $scope.currentCategory = cat
        itemsQuery = (Item.query {category_id: cid}).$promise
        itemsQuery.then (items)->
          $scope.currentCategory.items = items

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

    $rootScope.$on "category:change", (_, id)->
      $scope.setCategory(id)

    categoriesQuery = (Category.query '').$promise
    categoriesQuery.then (categories)->
      $scope.categories = categories


    $scope.filters = { count: '!0', body: undefined }

    $q.all([categoriesQuery])
      .then ->
        $scope.ready = true
        $rootScope.$emit 'category_controller:ready'

  $scope.init()


@category.controller 'CategoriesCtrl', ['$scope', '$rootScope', '$resource', '$location', '$modal', '$q', '$window', CategoriesCtrl]
