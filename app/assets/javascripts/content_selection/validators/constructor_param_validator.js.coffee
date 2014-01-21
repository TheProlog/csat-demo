
#= require util/gateway

class _ConstructorParamValidator

  doValidation = (params, validators) ->
    GenericValidator = window.meldd_gateway.use 'CSGenericValidator'
    new GenericValidator().validate params, validators

  getParams = (params_in) ->
    Object.merge {ident: 'ContentSelection constructor'}, params_in

  getValidators = ->
    [
      {
        message: 'requires a parameter.'
        isValid: (params) -> params.selector
      },
      {
        message: 'was passed an invalid selector.'
        isValid: (params) -> $(params.selector).length
      }
    ]

  constructor: -> ;

  validate: (params_in) ->
    doValidation getParams(params_in), getValidators()

window.meldd_gateway.register 'CSConstructorParamValidator',
    _ConstructorParamValidator, 'CSValidators'
