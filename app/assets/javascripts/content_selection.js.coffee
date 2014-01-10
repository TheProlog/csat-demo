
#= require util/gateway

class GenericValidator

  throwErrorFor = (ident, tail) ->
    message = [ident, tail].join ' '
    throw new Error message

  validateItem = (params, validator) ->
    throwErrorFor params.ident, validator.message unless validator.isValid(params)

  constructor: -> ;

  validate: (params, validators) ->
    for validator in validators
      validateItem params, validator

class ConstructorParamValidator

  constructor: -> ;

  validate: (params_in) ->
    validators = [
      {
        message: 'requires a parameter.'
        isValid: (params) -> params.selector
      },
      {
        message: 'was passed an invalid selector.'
        isValid: (params) -> $(params.selector).length
      }
    ]
    params = Object.merge {ident: 'ContentSelection constructor'}, params_in
    new GenericValidator().validate params, validators

class SelectorValidator

  constructor: -> ;

  validate: (params) ->
    validators = [
      {
        message: 'was passed an invalid or nonexistent selector.'
        isValid: (params) -> $(params.selector).length
      }
    ]
    new GenericValidator().validate params, validators

class NodeIndexValidator

  childNodesFor = (selector) ->
    $(selector).get(0).childNodes

  buildParams = (params_in) ->
    childNodes = childNodesFor params_in.selector
    Object.merge {childNodes}, params_in

  constructor: -> ;

  validate: (params_in) ->
    validators = [
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
    new GenericValidator().validate buildParams(params_in), validators

class TextOffsetValidator

  getNodeFor = (selector, index) ->
    $(selector).get(0).childNodes[index]

  validateOffset = (textOffset, node, ident) ->
    unless textOffset in [0...node.nodeValue.length]
      throw new Error ident + ' was passed an invalid text offset.'

  constructor: -> ;

  validate: (params_in) ->
    validators = [
      {
        message: 'was passed an invalid text offset.'
        isValid: (params) ->
          node = getNodeFor params.selector, params.nodeIndex
          params.textOffset in [0...node.nodeValue.length]
      }
    ]
    new GenericValidator().validate params_in, validators

################################################################################
################################################################################
################################################################################

window.meldd_gateway.register 'ContentSelection', class

  validateEndpoint = (params) ->
    for klass in [SelectorValidator, NodeIndexValidator, TextOffsetValidator]
      new klass().validate params

  constructor: (@baseSelector) ->
    new ConstructorParamValidator().validate {selector: @baseSelector}

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
