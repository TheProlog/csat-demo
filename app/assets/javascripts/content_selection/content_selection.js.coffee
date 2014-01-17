
#= require util/gateway

window.meldd_gateway.register 'ContentSelection', class

  combineNodesAsString = (contents) ->
    childNodes_to_a = ->
      ret = []
      # childNodes is a NodeList, *not* an Array. Pfffft.
      for index in [0...@length]
        ret.push @item(index)
      ret
    func = (p,c,i,a) =>
      newValue = if c.outerHTML then c.outerHTML else c.nodeValue
      p + newValue
    childNodes_to_a.call(contents.childNodes).reduce(func, '')

  getSelectionContents = ->
    r1 = document.createRange()
    r1.selectNode($(@startSelector).get(0).childNodes[@startNodeIndex])
    r1.setStart(r1.startContainer.childNodes[0], @startTextOffset)
    r2 = document.createRange()
    r2.selectNode($(@endSelector).get(0).childNodes[@endNodeIndex])
    r1.setEnd(r2.startContainer.childNodes[@endNodeIndex], @endTextOffset)
    combineNodesAsString(r1.cloneContents())

  validateEndpoint = (params) ->
    for klass in window.meldd_gateway.useGroup 'CSValidators'
      new klass().validate params

  endpointIsValid = (selector, nodeIndex, textOffset) ->
    selector and nodeIndex? and textOffset?

  verifyEndpoints = ->
    unless endpointIsValid @startSelector, @startNodeIndex, @startTextOffset
      which = 'starting'
    else
      unless endpointIsValid @endSelector, @endNodeIndex, @endTextOffset
        which = 'ending'
    throw new Error('Selection {1} point not set!'.assign(which)) if which

  constructor: (@baseSelector) ->
    Validator = window.meldd_gateway.use 'CSConstructorParamValidator'
    new Validator().validate {selector: @baseSelector}

  setStart: (selector, nodeIndex, textOffset) ->
    ident = 'setStart'
    validateEndpoint {selector, nodeIndex, textOffset, ident}
    @startSelector = selector
    @startNodeIndex = nodeIndex
    @startTextOffset = textOffset

  setEnd: (selector, nodeIndex, textOffset) ->
    ident = 'setEnd'
    validateEndpoint {selector, nodeIndex, textOffset, ident}
    @endSelector = selector
    @endNodeIndex = nodeIndex
    @endTextOffset = textOffset

  getContent: ->
    verifyEndpoints.call @
    getSelectionContents.call @
