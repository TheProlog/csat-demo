
#= require util/gateway

window.meldd_gateway.register 'BoundedIntegerValidator', class

  verifyValueIsNumeric = ->
    throw 'Value must be a number' if isNaN(@value.toInt())

  verifyValueIsAnInteger = ->
    throw 'Value must be an integer' if @value.toInt() != @value.toFloat()

  verifyValueIsNotNegative = ->
    message = 'Value must not be less than ' + @minValue
    throw message if @value.toInt() < @minValue

  verifyValueIsWithinBounds = ->
    message = 'Value must not be greater than ' + @maxValue
    throw message if @value.toInt() > @maxValue

  validators = ->
    [verifyValueIsNumeric,
    verifyValueIsAnInteger,
    verifyValueIsNotNegative,
    verifyValueIsWithinBounds]

  constructor: (params_in) ->
    @value = params_in.value
    @maxValue = params_in.maxValue
    @minValue = params_in.minValue || 0
    @message = ''

  validate: ->
    try
      func.call @ for func in validators()
    catch message
      @message = message
    null  # no meaningful return value; kill any attempted chaining gruesomely
