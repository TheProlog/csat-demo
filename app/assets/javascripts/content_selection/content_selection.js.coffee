
#= require util/gateway

window.meldd_gateway.register 'ContentSelection', class

  combineNodesAsString = (contents_in) ->
    contents = Object.clone(contents_in)
    contents.childNodes.to_a = ->
      ret = []
      # childNodes is a NodeList, *not* an Array. Pfffft.
      for index in [0...@length]
        ret.push @item(index)
      ret
    func = (p,c,i,a) =>
      newValue = if c.outerHTML then c.outerHTML else c.nodeValue
      p + newValue
    contents.childNodes.to_a().reduce(func, '')

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
    getSelectionContents.call @
