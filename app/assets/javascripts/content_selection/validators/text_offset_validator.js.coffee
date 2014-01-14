
#= require util/gateway

class _TextOffsetValidator

  doValidation = (params, validators) ->
    GenericValidator = window.meldd_gateway.use 'CSGenericValidator'
    new GenericValidator().validate params, validators

  getNodeFor = (selector, index) ->
    $(selector).get(0)?.childNodes[index]

  getParams = (params_in) -> params_in;

  getValidators = ->
    [
      {
        message: 'was passed an invalid text offset.'
        isValid: (params) ->
          node = getNodeFor params.selector, params.nodeIndex
          return false unless node
          params.textOffset in [0...node.nodeValue.length]
      }
    ]

  constructor: -> ;

  validate: (params_in) ->
    doValidation getParams(params_in), getValidators()

window.meldd_gateway.register 'CSTextOffsetValidator', _TextOffsetValidator,
    'CSValidators'
