
#= require util/gateway

describe 'CSTextOffsetValidator class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CSTextOffsetValidator'

  describe 'conforms to our content-selection validator API, with a', ->

    it 'constructor taking no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it '"validate" method taking one parameter', ->
      obj = new @klass()
      expect(obj.validate).to.be.a 'function'
      expect(obj.validate).to.have.length 1

  describe 'has a "validate" method that', ->

    beforeEach ->
      @obj = new @klass()

    describe 'fails when passed a parameter object with', ->

      beforeEach ->
        fixture.set '<p id="foo">This <em>is</em> a test.</p>'
        @params = {
          selector:   'p:nth-child(1)'
          nodeIndex:  0
          textOffset: 271828
          ident:      'ContentSelection constructor'
        }
        @expected = 'ContentSelection constructor was passed '

      afterEach ->
        expect(=> @obj.validate(@params)).to.throwError((e) =>
          expect(e.message).to.be @expected
        )

      it 'an invalid text offset', ->
        @expected += 'an invalid text offset.'

    describe 'succeeds when passed a parameter object with', ->

      it 'a valid "textOffset" key/value', ->
        fixture.set '<p id="foo">This <em>is</em> a test.</p>'
        params = {selector: 'p#foo', nodeIndex: 2, textOffset: 4}
        expect(=> @obj.validate(params)).to.not.throwError()
