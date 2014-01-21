
#= require util/gateway

describe 'CsatFormInitialiser class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CsatFormInitialiser'

  describe 'has an API consisting of', ->

    it 'a constructor which takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'a "setup" method which takes one parameter', ->
      obj = new @klass()
      expect(obj.setup).to.be.a 'function'
      expect(obj.setup).to.have.length 1

  it 'needs more specs for code riddled with direct jQuery calls'
