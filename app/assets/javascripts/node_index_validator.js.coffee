
#= require util/gateway

window.meldd_gateway.register 'NodeIndexValidator', class

  createValidator = (params) ->
    Validator = window.meldd_gateway.use 'BoundedIntegerValidator'
    new Validator(params)

  getLimitBasedOn = (field) ->
    NodeIndexLimitFinder = window.meldd_gateway.use 'NodeIndexLimitFinder'
    new NodeIndexLimitFinder().getLimit(field)

  constructor: (params_in) ->
    @maxValue = getLimitBasedOn(params_in.field)
    @value = params_in.field.val()
    @message = ''

  validate: ->
    validator = createValidator({value: @value, maxValue: @maxValue})
    validator.validate()
    @message = validator.message
    null  # no meaningful return value; kill any attempted chaining gruesomely
