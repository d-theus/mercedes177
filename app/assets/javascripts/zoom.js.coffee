# 
# Requires okzoom
#

window.Zoom =
  enabled: false
  __options:
    width: 300
    round: true
    scaleWidth: 3280
  on: ->
    $('.ok-listener').remove()
    $('.with-loupe').okzoom(Zoom.__options)
    Zoom.enabled = true

  off: ->
    $('.ok-listener').unbind('mousemove')
    $('#ok-loupe').remove()
    $('.ok-listener').css('cursor', 'auto')
    $('.with-loupe').unbind('mousemove')
    Zoom.enabled = false

  toggle: ->
    if Zoom.enabled then Zoom.off() else Zoom.on()

