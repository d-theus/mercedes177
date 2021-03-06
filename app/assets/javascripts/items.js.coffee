@item = angular.module('item', ['ngResource', 'ngAnimate', 'ngCookies', 'ui.bootstrap'])
ItemCtrl = ($scope, $rootScope, $resource, $location, $modal, $q, $timeout) ->
  Item = $resource('/items/:id', {id: '@id' }, {update: {method: 'PUT'}})
  ItemPhoto = $resource('/items/:item_id/photos/:id', { item_id: '@item_id', id: '@id'}, { query: { isArray: false}})
  $scope.editing = { }

  $scope.setItem = (id)->
    console.log 'setItem()'
    $scope.ready = false
    unless Number(id)
      $scope.item = null
      $scope.ready = true
      return
    (Item.get id: id).$promise
    .then (response)->
      $scope.item = response
      $scope.item.currentPhoto = preview: null
      return $q.resolve($scope.item)
    .then (item)->
      return (ItemPhoto.query item_id: $scope.item.id).$promise
    .then (resp)->
      $scope.item.photos = resp.photos
      $scope.item.featuredPhoto = resp.featured
      $scope.item.currentPhoto = resp.featured || $scope.item.photos[0]
      $scope.item.properties ||= {}
      return $q.resolve(true)
    .then ->
      $scope.ready = true
      return $q.resolve($scope.ready)

  $scope.toggleControl = (ct, val = null)->
    if typeof($scope.editing[ct]) != undefined
      $scope.editing[ct] = val || !$scope.editing[ct]
    else
      $scope.editing[ct] = val || true

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

  $scope.submit = (attr, tochange = false)->
    if $scope.item[attr]
      upd = {}
      upd.id = $scope.item.id
      upd[attr] = $scope.item[attr]
      Item.update upd, ->
        $scope.editing[attr] = false
        if tochange
          $scope.$emit 'item:tochange', $scope.item.id

  $scope.chooseFile = ()->
    $scope.files ||= []
    $scope.editing.photos = "choose"

  $scope.uploadPhotos = (files)->
    return unless ($scope.editing.photos == "choose") && files && files[0]
    count0 = $scope.files.length

    for newf in files
      for oldf in $scope.files
        if newf.lastModified == oldf.lastmod && newf.name == oldf.name
          alert "Похоже, файл #{newf.name} уже выбран! Отмена."
          return

    Array::forEach.call files, (file)->
      upload = { name: file.name, lastmod: file.lastModified, progress: 0 }

      fr = new FileReader()
      fr.onloadend = (e)->
          upload.data = e.target.result

          $timeout ->
            $scope.files.push upload
            if ($scope.files.length - count0) == files.length
              $scope.editing.photos = "prompt"
              Array::splice(files, 0, files.length)
      fr.readAsDataURL(file)

  $scope.removeFile = (name)->
    for f, id in $scope.files
      if f.name == name
        $scope.files.splice(id,1)
        break

  $scope.savePhotos = ()->
    if file = $scope.files.filter((e)-> e.progress < 100).pop()
      photo = new ItemPhoto
      photo.data = file.data
      file.progress = 10
      photo.$save(item_id: $scope.item.id)
        .then ->
          file.progress = 100
          $scope.savePhotos()
        .catch ->
          file.progress = -1
          if confirm('Фото не загрузилось, попробовать еще?')
            $scope.savePhotos()
          else
            $scope.files.splice(0)
            $scope.editing.photos = false
            $scope.$emit 'item:tochange', $scope.item.id
    else
      $scope.files.splice(0)
      $scope.editing.photos = false
      $scope.$emit 'item:tochange', $scope.item.id

  $scope.deletePhoto = ->
    ItemPhoto.delete(id: $scope.item.currentPhoto.id, item_id: $scope.item.id)
    $scope.$emit 'item:tochange', $scope.item.id

  $scope.featurePhoto = ->
    Item.update(id: $scope.item.id, featured_photo_id: $scope.item.currentPhoto.id)
    $scope.$emit 'item:tochange', $scope.item.id

  $scope.openPhotoPreview = ()->
    modal = $modal.open(
      scope: $scope
      size: 'lg'
      templateUrl: '/templates/items/preview_modal'
      windowClass: 'modal-xl'
    )
    modal.result.then ->
      Zoom.off()

  $scope.removeProperty = (name)->
    delete $scope.item.properties[name]

  $scope.addProperty = (name = 'название характеристики')->
    $scope.item.properties[name] = ''

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
    $rootScope.$on 'item:change', (_, id)->
      console.log 'item:change catched'
      $scope.setItem(id)

    $scope.$emit 'item_controller:ready'

  $scope.init()

@item.controller 'ItemCtrl', ['$scope', '$rootScope', '$resource', '$location', '$modal', '$q', '$timeout', ItemCtrl]

