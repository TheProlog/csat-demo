
#= require util/gateway

window.meldd_gateway.register 'TextOffsetValidator', class

  # identical to method in NodeIndexValidator
  createValidator = (params) ->
    Validator = window.meldd_gateway.use 'BoundedIntegerValidator'
    new Validator(params)

  getContentNodeFor = (field) ->
    NodeFinder = window.meldd_gateway.use 'CsatSelectorElementNodeFinder'
    new NodeFinder().find field

  getNodeIndexFor = (field) ->
    Finder = window.meldd_gateway.use 'CsatNodeIndexFinder'
    new Finder().find(field)

  # differs from method in NodeIndexValidator only in validator class name
  getLimitBasedOn = (field) ->
    TextOffsetLimitFinder = window.meldd_gateway.use 'TextOffsetLimitFinder'
    new TextOffsetLimitFinder().getLimit(field)

  findNodeBasedOn = (field) ->
    elementNode = getContentNodeFor field
    nodeIndex = getNodeIndexFor field
    elementNode.childNodes[nodeIndex]

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
