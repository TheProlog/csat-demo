
#= require util/gateway

setupFixture = ->
  content_para = 'This is a test. <em>This is only a test.</em> That ' +
    'is all.'
  base_div = [
    '<div id="base"><div id="content"><p>',
    '</p></div></div>'].
    join content_para
  fixture.set base_div + '<div id="other"><p>This is something else.</p></div>'

describe 'TextNodeFinder class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'TextNodeFinder'
    setupFixture()

  describe 'has a constructor that', ->

    it 'takes one parameter', ->
      expect(@klass).to.have.length 1

    it 'requires the parameter to initialise the "baseSelector" property', ->
      obj = new @klass()
      expect(obj.baseSelector).to.be undefined
      obj = new @klass '#foo'
      expect(obj.baseSelector).to.be '#foo'

  describe 'has a "firstTextNode" method that, when the parameter is', ->

    beforeEach ->
      @obj = new @klass '#content'

    it 'omitted, returns the first text node within the base selector', ->
      node = @obj.firstTextNode()
      expect(node.nodeType).to.be Node.TEXT_NODE
      expect(node.nodeValue).to.be 'This is a test. '

    it 'a text node, returns the same value passed in', ->
      param = $('#content p').get(0).childNodes[0]
      expect(@obj.firstTextNode param).to.be param

    it 'an element node, returns the first child text node of the element', ->
      param = $('#content p').get(0)
      expect(@obj.firstTextNode param).to.be param.childNodes[0]

    it "a jQuery object, returns the first child text node in its element", ->
      param = $('#content p')
      expect(@obj.firstTextNode param).to.be param.get(0).childNodes[0]
