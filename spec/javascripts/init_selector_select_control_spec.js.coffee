
#= require util/gateway

describe 'InitSelectorSelectControl class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'InitSelectorSelectControl'
    html = '<div id="content"><p>This is a test.</p></div>'
    fixture.set html

  describe 'has an API that includes', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass.length).to.be 0

    it 'a "setup" method that takes one parameter', ->
      obj = new @klass()
      expect(obj.setup).to.be.a 'function'
      expect(obj.setup.length).to.be 1

  describe 'the setup method', ->

    it 'returns a null value', ->
      obj = new @klass()
      selector = 'p:nth-child(1)'
      expect(obj.setup({selector})).to.be null

  it 'needs more specs to cover the "setup" method'

