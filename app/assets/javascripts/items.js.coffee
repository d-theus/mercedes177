@item = angular.module('item', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap'])
ItemCtrl = ($scope, $rootScope, $resource, $location, $modal, $q) ->
  Item = $resource('/items/:id', {id: '@id' }, {update: {method: 'PUT'}})
  ItemPhoto = $resource('/items/:item_id/photos/:id', { item_id: '@item_id', id: '@id'})
  $scope.editing = { }
  $scope.ready = false

  $scope.setItem = ->
    $scope.ready = false
    unless iid = Number($location.search().item)
      $scope.item = null
      $scope.ready = true
      return
    (Item.get id: iid).$promise
    .then (response)->
      $scope.item = response
      $scope.item.currentPhoto = preview: null
      return $q.resolve($scope.item)
    .then (item)->
      return (ItemPhoto.query item_id: $scope.item.id).$promise
    .then (photos)->
      $scope.item.photos = photos
      $scope.item.currentPhoto = photos[0] if photos[0]
      return $q.resolve(true)
    .then ->
      $scope.ready = true
      return $q.resolve($scope.ready)

  $scope.toggleControl = (ct, val = null)->
    if typeof($scope.editing[ct]) != undefined
      $scope.editing[ct] = val || !$scope.editing[ct]
    else
      $scope.editing[ct] = val || true
      # FIXME
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
      photo.data = file.data
      photo.$save(item_id: $scope.item.id)
    $scope.files.splice(0)
    $scope.editing.photos = false
    $scope.setItem($scope.item)

  $scope.deletePhoto = ->
    ItemPhoto.delete(id: $scope.item.currentPhoto.id, item_id: $scope.item.id)
    $scope.$emit 'item:tochange'

  $scope.openPhotoPreview = ()->
    modal = $modal.open(
      scope: $scope
      size: 'lg'
      templateUrl: '/templates/items/preview_modal'
      windowClass: 'modal-xl'
    )
    modal.result.then ->
      Zoom.off()

  $scope.delete = ()->
    return unless confirm "Удалить товар\n#{$scope.item.name}?"
    $scope.item.$remove()
    $location.search('item', null)
    $location.search('cat', $scope.item.category_id)
    window.location = '#' + $location.url()
    window.location.reload()

  $scope.archive = ->
    Item.update({
      id: $scope.item.id
      count: 0
    })
    $scope.$emit 'item:tochange'

  $scope.putToCart = ()->
    $scope.$emit 'cart:put', $scope.item

  $scope.putToCartAndProceed = ()->
    $scope.$emit 'cart:put-and-checkout', $scope.item

  $scope.init = ->
    $scope.ready = false
    $rootScope.$on 'item:tochange', $scope.setItem
    $scope.setItem()

  $scope.init()

@item.controller 'ItemCtrl', ['$scope', '$rootScope', '$resource', '$location', '$modal', '$q', ItemCtrl]

