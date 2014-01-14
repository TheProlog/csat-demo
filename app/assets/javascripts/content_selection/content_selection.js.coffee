
#= require util/gateway

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
    for klass in [TextOffsetValidator]
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
