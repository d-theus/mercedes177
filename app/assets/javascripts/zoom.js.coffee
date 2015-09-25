# 
# Requires okzoom
#

window.Zoom =
  enabled: false
  on: ->
    $('.ok-listener').remove()
    $('.with-loupe').okzoom()
    Zoom.enabled = true

  off: ->
    $('.ok-listener').unbind('mousemove')
    $('#ok-loupe').remove()
    $('.ok-listener').css('cursor', 'auto')
    $('.with-loupe').unbind('mousemove')
    Zoom.enabled = false

  toggle: ->
    if Zoom.enabled then Zoom.off() else Zoom.on()
