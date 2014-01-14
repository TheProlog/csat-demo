
#= require util/gateway

describe 'CSNodeIndexValidator class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CSNodeIndexValidator'

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
          nodeIndex:  271
          textOffset: 0
          ident:      'ContentSelection constructor'
        }
        @expected = 'ContentSelection constructor was passed '

      afterEach ->
        expect(=> @obj.validate(@params)).to.throwError((e) =>
          expect(e.message).to.be @expected
        )

      it 'an invalid node index', ->
        @expected += 'an invalid node index.'

      it 'a node index for a non-text node', ->
        @params.nodeIndex = 1
        @expected += 'a node index for a non-text node.'

    describe 'succeeds when passed a parameter object with', ->

      it 'a valid "nodeIndex" key/value', ->
        fixture.set '<p id="foo">This <em>is</em> a test.</p>'
        params = {selector: 'p#foo', nodeIndex: 2, textOffset: 0}
        expect(=> @obj.validate(params)).to.not.throwError()
