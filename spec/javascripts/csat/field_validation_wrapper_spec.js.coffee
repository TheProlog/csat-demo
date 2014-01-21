
#= require util/gateway

failureMessageFormat = '{1} cannot help but fail; such is its lot in life.'

class BaseValidator

  constructor: (params) ->
    @field = params.field || 'What field?!?'

class FailingValidator extends BaseValidator

  validate: ->
    @message = failureMessageFormat.assign(@field)

class SuccessfulValidator extends BaseValidator

  validate: ->
    @message = ''

describe 'CsatFieldValidationWrapper class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CsatFieldValidationWrapper'

  describe 'has a basic API that includes', ->

    it 'a constructor taking no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'a "setup" method taking two parameters', ->
      obj = new @klass()
      expect(obj.setup).to.be.a 'function'
      expect(obj.setup).to.have.length 2

  describe 'the "setup" method', ->

    beforeEach ->
      @obj = new @klass()
      @validatorClassName = 'CFVW Validator'

    afterEach ->
      message = @obj.setup 'theField', @validatorClassName
      expect(message).to.be @expected

    it 'returns `undefined` when the field is validated successfully', ->
      @expected = undefined
      window.meldd_gateway.register @validatorClassName, SuccessfulValidator

    it 'returns the correct error message when the field validation fails', ->
      @expected = '* ' + failureMessageFormat.assign 'theField'
      window.meldd_gateway.register @validatorClassName, FailingValidator
