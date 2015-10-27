@about = angular.module('about', ['ngAnimate', 'ui.bootstrap', 'search', 'cart'])
@about.controller 'YMCtrl', ($scope, $http, $element) ->

      #s = $('<script>')
      #ymc.append(s)
      #s.attr(
        #src: "https://api-maps.yandex.ru/services/constructor/1.0/js/?sid=24sj7y_fyH0Rf9ssYZUGRbke40L5q-_5&width=#{ymc.width()}&height=450"
        #async: true
        #charset: 'utf-8'
        #type: 'text/javascript')

      #$(window).on 'resize', ->
        #ymc.children().first().width('100%')
