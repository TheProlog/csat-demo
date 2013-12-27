
#= require util/gateway

describe 'BoundedIntegerValidator class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'BoundedIntegerValidator'

  describe 'has a public API that includes', ->

    it 'a constructor that takes 1 parameter', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 1

    it 'a "validate" method that takes no parameters', ->
      params = {value: 1, maxValue: 2, minValue: 0}
      theClass = window.meldd_gateway.use 'BoundedIntegerValidator'
      obj = new theClass(params)
      expect(obj.validate).to.be.a 'function'
      expect(obj.validate).to.have.length 0

  describe 'when initialised with', ->

    beforeEach ->
      @params = {maxValue: 10}
      @message = undefined

    afterEach ->
      obj = new @klass @params
      obj.validate()
      expect(obj.message).to.be @message

    describe 'the default "minValue" of zero', ->

      it 'a "value" between 0 and the "maxValue" is valid', ->
        @params.value = 5
        @message = ''

      it 'a "value" below 0 is not valid', ->
        @params.value = -1
        @message = 'Value must not be less than 0'

      it 'a "value" above the "maxValue" is not valid', ->
        @params.value = 20
        @message = 'Value must not be greater than ' +
            @params.maxValue.toString()

      it 'a non-integer "value" is not valid', ->
        @params.value = 2.7182818
        @message = 'Value must be an integer'

      it 'a non-numeric "value" is not valid', ->
        @params.value = 'bogus'
        @message = 'Value must be a number'

      it 'an empty string "value" is not valid', ->
        @params.value = ''
        @message = 'Value must be a number'

    describe 'an explicitly set "minValue"', ->

      beforeEach ->
        @params.minValue = 5

      it 'a "value" between the "minValue" and "maxValue" is valid', ->
        @params.value = 8
        @message = ''

      it 'a "value" below the "minValue" is not valid', ->
        @params.value = 0
        @message = 'Value must not be less than 5'

      it 'a "value" above the "maxValue" is not valid', ->
        @params.value = 20
        @message = 'Value must not be greater than ' +
            @params.maxValue.toString()

      it 'a non-integer "value" is not valid', ->
        @params.value = 2.7182818
        @message = 'Value must be an integer'

      it 'a non-numeric "value" is not valid', ->
        @params.value = 'bogus'
        @message = 'Value must be a number'

      it 'an empty string "value" is not valid', ->
        @params.value = ''
        @message = 'Value must be a number'
