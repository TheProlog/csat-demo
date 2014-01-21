
#= require util/gateway

window.meldd_gateway.register 'CsatFieldValidationWrapper', class

  formatValidationMessage = (message) ->
    if message.length == 0
      undefined
    else
      '* ' + message

  getValidatorInstance = (validatorClass, params) ->
    Validator = window.meldd_gateway.use validatorClass
    new Validator(params)

  constructor: -> ;

  setup: (field, validatorClass) ->
    obj = getValidatorInstance validatorClass, {field}
    obj.validate()
    formatValidationMessage obj.message
