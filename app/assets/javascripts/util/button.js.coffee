
#= require util/gateway

window.meldd_gateway.register 'UtilButton', class

  constructor: ->
    @attrs = {type: 'button'}
    @classes = ['button']

  html: (innerHtml = 'BUTTON?!?') ->
    ret = $('<button>').attr(@attrs)
    ret.addClass(klass) for klass in @classes
    ret.html innerHtml
    ret.get(0).outerHTML
