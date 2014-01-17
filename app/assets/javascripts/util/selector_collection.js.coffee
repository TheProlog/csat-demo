
#= require util/gateway

window.meldd_gateway.register 'SelectorCollection', class

  _getBuilder = ->
    SelectorBuilder = window.meldd_gateway.use 'SelectorBuilder'
    new SelectorBuilder '.boilerplate'

  _getSelectorsInChild = (baseElement) ->
    ret = []
    ret.add @builder.selectorFor baseElement
    for child in baseElement.children()
      ret.add _getSelectorsInChild.call(@, $(child))
    ret

  constructor: (@baseSelector) ->
    @builder = _getBuilder()

  collection: ->
    ret = []
    # NOTE: WHEN ITERATING, child is a DOM node, NOT a jQuery object!
    #       Ask for something like `$(@baseSelector).children().first()`, and
    #       you'll get handed a jQuery object. This is a CoffeeScript auto-
    #       conversion-during-iteration "feature", not a jQuery bug.
    for child in $(@baseSelector).children()
      ret.add _getSelectorsInChild.call @, $(child)
    ret

