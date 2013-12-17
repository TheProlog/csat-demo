
#= require util/gateway

window.meldd_gateway.register 'SelectionWrapper', class

  constructor: (@base_selector = '#content') ->
    firstTextNode = (selector) ->
      node = $(selector).get(0)
      node = node.childNodes[0] while node?.nodeType == Node.ELEMENT_NODE
      node

    nodeAndOffsetFor = (which, baseSelector) ->
      r = $.Range.current()
      if r.range.collapsed
        node = firstTextNode(baseSelector) || getDocument()
        offset = 0
      else
        node = r[which]().container
        offset = r.range[which + 'Offset']
      [node, offset]

    makeEndpoint = (which, baseSelector) ->
      [node, offset] = nodeAndOffsetFor which, baseSelector
      Endpoint = window.meldd_gateway.use 'Endpoint'
      new Endpoint node, offset

    @start = makeEndpoint 'start', @base_selector
    @end = makeEndpoint 'end', @base_selector
    @parent = $.Range.current().parent()

  # LoD mitigation

  startSelector: ->
    @start.selector()

  endSelector: ->
    @end.selector()

  startNodeIndex: ->
    @start.nodeIndex()

  endNodeIndex: ->
    @end.nodeIndex()

  startOffset: ->
    @start.textOffset()

  endOffset: ->
    @end.textOffset()