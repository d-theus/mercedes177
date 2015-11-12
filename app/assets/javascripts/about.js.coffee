@about = angular.module('about', ['ngAnimate', 'ui.bootstrap', 'search', 'cart'])

MapCtrl = ($scope, $element)->
  $scope.init = ->
    $element.append(s)

  $scope.init()


@about.controller 'MapCtrl', ['$scope', '$element', MapCtrl]

@about.directive 'mapContainer', ->
    return template: (elem, attr)->
      '<div id=ymcontainer><script type="text/javascript" charset="utf-8" async=true src="https://api-maps.yandex.ru/services/constructor/1.0/js/?sid=x5wjXGIQoYyq-toz1S59tZE5ufehN0MF&width=' + elem.width().toString() + '&height=400&lang=ru_RU&sourceType=constructor&id=ymcontainer" ></script></div>'

