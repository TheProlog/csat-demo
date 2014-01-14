
#= require util/gateway

class NodeIndexValidator

  childNodesFor = (selector) ->
    $(selector).get(0)?.childNodes

  doValidation = (params, validators) ->
    GenericValidator = window.meldd_gateway.use 'CSGenericValidator'
    new GenericValidator().validate params, validators

  getParams = (params_in) ->
    childNodes = childNodesFor params_in.selector
    Object.merge {childNodes}, params_in

  getValidators = ->
    [
      {
        message: 'was passed an invalid node index.'
        isValid: (params) ->
          params.nodeIndex in [0...params.childNodes.length];
      },
      {
        message: 'was passed a node index for a non-text node.'
        isValid: (params) ->
          params.childNodes[params.nodeIndex].nodeType == Node.TEXT_NODE
      }
    ]

  constructor: -> ;

  validate: (params_in) ->
    doValidation getParams(params_in), getValidators()

class TextOffsetValidator

  doValidation = (params, validators) ->
    GenericValidator = window.meldd_gateway.use 'CSGenericValidator'
    new GenericValidator().validate params, validators

  getNodeFor = (selector, index) ->
    $(selector).get(0).childNodes[index]

  getParams = (params_in) -> params_in;

  getValidators = ->
    [
      {
        message: 'was passed an invalid text offset.'
        isValid: (params) ->
          node = getNodeFor params.selector, params.nodeIndex
          params.textOffset in [0...node.nodeValue.length]
      }
    ]

  constructor: -> ;

  validate: (params_in) ->
    doValidation getParams(params_in), getValidators()

################################################################################
################################################################################
################################################################################

window.meldd_gateway.register 'ContentSelection', class

  validateEndpoint = (params) ->
    for klass in window.meldd_gateway.useGroup 'CSValidators'
      new klass().validate params
    for klass in [NodeIndexValidator, TextOffsetValidator]
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
    ;

  getContent: ->
    ;
