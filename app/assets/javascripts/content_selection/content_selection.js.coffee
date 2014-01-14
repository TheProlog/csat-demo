
#= require util/gateway

window.meldd_gateway.register 'ContentSelection', class

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
    ;
