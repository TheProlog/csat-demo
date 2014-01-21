
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

window.meldd_gateway.register 'CSGenericValidator', GenericValidator
