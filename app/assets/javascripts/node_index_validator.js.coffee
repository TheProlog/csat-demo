
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

window.meldd_gateway.register 'TextOffsetValidator', class

  findNodeBasedOn = (field) ->
    throw 'This should return the node specified by selector and node index'

  getLimitBasedOn = (field) ->
    throw 'This should return the maximum text offset for the relevant node'

  createValidator = (params) ->
    throw 'Unimplemented'

  constructor: (params_in) ->
    @node = findNodeBasedOn(params_in.field)
    @maxValue = getLimitBasedOn(params_in.field)
    @value = params_in.field.val()
    @message = ''

  validate: ->
    validator = createValidator({
      value:    @value
      maxValue: @maxValue
      node:     @node
    })
    validator.validate()
    @message = validator.message
    null
