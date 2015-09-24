@catalog = angular.module('catalog', ['ngResource'])
@catalog.controller 'CategoriesCtrl', ($scope, $resource, $location) ->

  Category = $resource('/categories/:id', {id: '@id'}, {update: {method: 'PUT'}})
  Item =     $resource('/items/:id',      {id: '@id'})
  $scope.categories = Category.query '', ->
    if (cid = Number($location.search().cat))
      for cat in $scope.categories
        if cat.id == cid
          cat.current = true

  $scope.items = Item.query '', ->
    if (iid = Number($location.search().item))
      for item in $scope.items
        if item.id == iid
          $scope.setItem(item)

  $scope.setItem = (item)->
    $('#catalog_container').scope().setItem(item)
    $location.search('item', item.id)

  $scope.open = (cat)->
    for c in $scope.categories
      c.current = false
    cat.current = true
    $location.search('cat', cat.id)

  $scope.close = (cat)->
    cat.current = false
    $location.search('')

  $scope.toggle = (cat)->
    if cat.current
      $scope.close(cat)
    else
      $scope.open(cat)

@catalog.controller 'ItemCtrl', ($scope, $resource) ->
  Item = $resource('/items/:id', {id: '@id' }, {update: {method: 'PUT'}})
  ItemPhoto = $resource('/items/:item_id/photos/:id', { item_id: '@item_id', id: '@id'})
  $scope.editing = { }

  $scope.setItem = (item)->
    $scope.item = item

  $scope.toggleControl = (ct)->
    if typeof($scope.editing[ct]) != undefined
      $scope.editing[ct] = !$scope.editing[ct]
    else
      $scope.editing[ct] = true

  $scope.submit = (attr)->
    if $scope.item[attr]
      upd = {}
      upd.id = $scope.item.id
      upd[attr] = $scope.item[attr]
      Item.update upd, ->
        # success
        #
        $scope.editing[attr] = false

  $scope.addPhoto = (file)->
    photo = new ItemPhoto
    #photo.image = file

    #photo.$save(item_id: $scope.item.id)

    fr = new FileReader()
    fr.onloadend = (e)->
      photo.image = e.target.result
      photo.$save(item_id: $scope.item.id)
    fr.readAsDataURL(file)
    true
