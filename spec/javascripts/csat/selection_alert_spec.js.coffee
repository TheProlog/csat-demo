
#= require util/gateway

describe 'SelectionAlert class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'SelectionAlert'

  describe 'has a basic API including', ->

    it 'a constructor which takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    describe 'a "show" method that', ->

      beforeEach ->
        @obj = new @klass()

      it 'takes one parameter', ->
        expect(@obj.show).to.be.a 'function'
        expect(@obj.show).to.have.length 1

      it 'can be called using a default parameter', ->
        foo = @obj.show()
        expect(=> @obj.show()).to.not.throwError()
