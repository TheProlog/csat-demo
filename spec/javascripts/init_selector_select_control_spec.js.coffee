
#= require util/gateway

describe 'InitSelectorSelectControl class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'InitSelectorSelectControl'

  describe 'has an API that includes', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass.length).to.be 0

    it 'a "setup" method that takes one parameter', ->
      obj = new @klass()
      expect(obj.setup).to.be.a 'function'
      expect(obj.setup.length).to.be 1

  it 'needs specs to cover the "setp" method'

