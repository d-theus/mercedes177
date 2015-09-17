# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class window.CatGroup
  this.formParams =
    async: true
    timeout: 10000
    cache: false

  this.errorDiv = (message)->
    "<div class=\"alert alert-danger\"><strong>Ошибка!</strong>#{if message then '<br/>' + message.toString()}</div>"

  constructor: (@el, @id) ->
    @formParams = CatGroup.formParams
    this.bindEvents()

  this.bindToList = (list)->
    this._array.splice(this._array.length)
    this._list = $(list)
    $(list).find('[data-model=CatGroup]').each (i, el)=>
      this.fromEl(el)

  this.bindAddButton = (btn)->
    $(btn).on 'click', =>
      this.getNew (panel)=>
        this._list.prepend(panel)

  this.getNew = ->
    @formParams.url = 'cat_groups/new'
    @formParams.success = (data) =>
      panel = $(data)
      this._list.prepend panel
      form = panel.find('#new_cat_group')
      form.on 'ajax:success', (e, data) =>
        panel.remove()
        new_panel = $(data)
        this._list.prepend new_panel
        this.fromEl new_panel
      form.on 'ajax:error', (e, data) =>
        panel.prepend( $(CatGroup.errorDiv data.responseText) )
    $.ajax(@formParams)

  this.fromEl = (el)->
    cg = new CatGroup($(el), $(el).data('id'))
    this._array.push(cg)
    return cg

  this._array = []

  getEditForm: (callback)->
    @formParams.url = "cat_groups/#{@id}/edit"
    @formParams.success = (data) -> callback( $(data) )
    @formParams.error =   (data) -> callback( $(CatGroup.errorDiv) )
    $.ajax(@formParams)

  bindEvents: ->
    @el.find('button[name="edit"]').on 'click', =>
      this.getEditForm (form)=>
        @el.find('button[name="edit"]').remove()
        @el.find('.panel-body').prepend(form)
        delBtn = form.find('a[name="delete"]')
        delBtn.on 'ajax:success', =>
          @el.remove()
        delBtn.on 'ajax:error',   =>
          @el.find('.panel-body').prepend($(CatGroup.errorDiv))

ready = ->
  CatGroup.bindToList('#catalog_list_accordion')
  CatGroup.bindAddButton('#catalog_list button[name="add"]')


$(document).ready ready
$(document).on 'page:load', ready
