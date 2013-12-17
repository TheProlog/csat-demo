
#= require util/gateway

window.meldd_gateway.register 'Endpoint', class

  makeNullObjectEndpointNode = (baseSelector) ->
    obj = $(baseSelector).get(0)

  parentElement = (endpointNode) ->
    return getDocument() unless endpointNode?.parentElement
    return endpointNode.parentElement || getDocument()

  constructor: (endpointNode, offset = 0, baseSelector = null) ->
    defaultBaseSelector = -> '#content'

    @baseSelector = baseSelector or defaultBaseSelector()
    @offset = offset || 0 # what if we have an invalid value here? Oops...
    TextNodeFinder = window.meldd_gateway.use 'TextNodeFinder'
    finder = new TextNodeFinder @baseSelector
    @endpointNode = finder.firstTextNode(endpointNode)

  nodeIndex: ->
    element = parentElement @endpointNode
    for child, i in element.childNodes
      return i if child == @endpointNode
    return 'How can this happen?'

  selector: ->
    SelectorBuilder = window.meldd_gateway.use 'SelectorBuilder'
    builder = new SelectorBuilder(@baseSelector)
    builder.selectorFor $(parentElement @endpointNode)

  textOffset: ->
    @offset

  sameNodeAs: (other) ->
    @selector() == other?.selector?() and @nodeIndex() == other?.nodeIndex?()

  containsElementFor: (otherNode) ->
    thisElement = parentElement @endpointNode
    otherElement = otherNode?.endpointNode?.parentElement
    return false unless otherElement
    thisElement.contains otherElement
