
#= require util/gateway

class ConstructorParamValidator

  validateParameter = (param) ->
    unless $(param).length
      throw param + ' is not a valid selector.'

  verifyParameterExists = (param) ->
    unless param
      throw 'ContentSelection constructor requires a parameter.'

  constructor: -> ;

  validate: (param) ->
    verifyParameterExists param
    validateParameter param

window.meldd_gateway.register 'ContentSelection', class

  constructor: (@baseSelector) ->
    new ConstructorParamValidator().validate @baseSelector

  setStart: (selector, nodeIndex, textOffset) ->
    ;

  setEnd: (selector, nodeIndex, textOffset) ->
    ;

  getContent: ->
    ;
