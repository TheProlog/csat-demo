
#= require util/gateway

describe 'CSConstructorParamValidator class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CSConstructorParamValidator'

  describe 'conforms to our content-selection validator API, with a', ->

    it 'constructor taking no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it '"validate" method taking one parameter', ->
      obj = new @klass()
      expect(obj.validate).to.be.a 'function'
      expect(obj.validate).to.have.length 1

  describe 'a "validate" method that', ->

    beforeEach ->
      @obj = new @klass()

    describe 'fails when passed a parameter object with', ->

      beforeEach ->
        @params = {}
        @expected = 'expected error message not set'

      afterEach ->
        expect(=> @obj.validate(@params)).to.throwError((e) =>
          expect(e.message).to.be @expected
        )

      it 'no "selector" key/value', ->
        @expected = 'ContentSelection constructor requires a parameter.'

      it 'a "selector" value that does not exist', ->
        @params = {selector: 'p#bogus'}
        @expected = 'ContentSelection constructor was passed an invalid' +
            ' selector.'

    describe 'succeeds when passed a parameter object with', ->

      it 'a valid "selector" key/value', ->
        fixture.set '<p id="foo">This is a test.</p>'
        params = {selector: 'p#foo'}
        expect(=> @obj.validate(params)).to.not.throwError()
