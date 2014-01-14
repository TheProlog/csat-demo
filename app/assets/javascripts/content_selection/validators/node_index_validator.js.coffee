
#= require util/gateway

class _NodeIndexValidator

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

window.meldd_gateway.register 'CSNodeIndexValidator', _NodeIndexValidator,
    'CSValidators'
