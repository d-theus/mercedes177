@catalog = angular.module('catalog', ['ngResource', 'ui.bootstrap'])
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

@catalog.controller 'ItemCtrl', ($scope, $resource, $modal) ->
  Item = $resource('/items/:id', {id: '@id' }, {update: {method: 'PUT'}})
  ItemPhoto = $resource('/items/:item_id/photos/:id', { item_id: '@item_id', id: '@id'})
  $scope.editing = { }

  $scope.setItem = (item)->
    $scope.item = item
    $scope.item.preview = '/images/placeholder.png'
    $scope.item.photos = ItemPhoto.query item_id: $scope.item.id, (photos)->
      # success
      #
      $scope.item.currentPhoto = photos[0] if photos[0]

  $scope.toggleControl = (ct, val = null)->
    if typeof($scope.editing[ct]) != undefined
      $scope.editing[ct] = val || !$scope.editing[ct]
    else
      $scope.editing[ct] = val || true
      console.log "switched control '#{ct}' to #{$scope.editing[ct]}"

  $scope.setPhoto = (photo)->
    $scope.item.currentPhoto = photo

  $scope.nextPhoto = ()->
    phs = $scope.item.photos
    id = phs.indexOf($scope.item.currentPhoto)
    $scope.item.currentPhoto = phs[(id+1) % phs.length]

  $scope.prevPhoto = ()->
    phs = $scope.item.photos
    id = phs.indexOf($scope.item.currentPhoto)
    $scope.item.currentPhoto = phs[(phs.length + id - 1) % phs.length]

  $scope.submit = (attr)->
    if $scope.item[attr]
      upd = {}
      upd.id = $scope.item.id
      upd[attr] = $scope.item[attr]
      Item.update upd, ->
        # success
        #
        $scope.editing[attr] = false

  $scope.chooseFile = ()->
    $scope.files ||= []
    $scope.editing.photos = "choose"

  $scope.uploadPhoto = (file)->
    return unless file
    for f in $scope.files
      if file.lastModified == f.lastmod
        if file.name == f.name
          alert 'Похоже, такой файл уже выбран!'
          return
    fr = new FileReader()
    fr.onloadend = (e)->
      $scope.$apply ->
        $scope.files.push { data: e.target.result, name: file.name, lastmod: file.lastModified }
        $scope.editing.photos = "prompt"
    fr.readAsDataURL(file)

  $scope.removeFile = (name)->
    for f, id in $scope.files
      if f.name == name
        $scope.files.splice(id,1)
        break

  $scope.savePhotos = ()->
    for file in $scope.files
      photo = new ItemPhoto
      photo.image = file.data
      photo.$save(item_id: $scope.item.id)
    $scope.files.splice(0)
    $scope.editing.photos = false
    $scope.setItem($scope.item)

  $scope.openPhotoPreview = ()->
    $modal.open(
      scope: $scope
      size: 'lg'
      templateUrl: '/templates/items/preview_modal'
    )
