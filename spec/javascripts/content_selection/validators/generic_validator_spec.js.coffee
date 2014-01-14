
#= require util/gateway

describe 'CSGenericValidator class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CSGenericValidator'

  describe 'has an API that includes', ->

    it 'a constructor which takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'a "validate" method that takes two parameters', ->
      obj = new @klass()
      expect(obj.validate).to.be.a 'function'
      expect(obj.validate).to.have.length 2

  describe 'the "validate" method', ->

    beforeEach ->
      @obj = new @klass()
      @validators = []
      @params = {ident: 'some spec'}

    describe 'does not raise an error given', ->

      it 'an empty "validators" array', ->
        expect(=> @obj.validate(@params, @validators)).to.not.throwError()

      description = 'all validators returning a truthy value from their ' +
          '"isValid" function'
      it description, ->
        @validators = [{
          message: 'anything at all'
          isValid: (params) -> true;
        }]
        expect(=> @obj.validate(@params, @validators)).to.not.throwError()

    description = "raises an error if a validator's " +
        '"isValid" function returns a non-truthy value'
    it description, ->
      @validators = [{
        message: 'This is an error message.'
        isValid: (params) -> false;
      }]
      expect(=> @obj.validate(@params, @validators)).to.throwError((e) =>
        expected = @params.ident + ' This is an error message.'
        expect(e.message).to.be expected
      )
