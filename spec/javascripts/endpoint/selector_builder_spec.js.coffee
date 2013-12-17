
#= require util/gateway

setupFixture = ->
  content_para = 'This is a test. <em>This is only a test.</em> That ' +
    'is all.'
  base_div = [
    '<div id="base"><div id="content"><p>',
    '</p></div></div>'].
    join content_para
  fixture.set base_div + '<div id="other"><p>This is something else.</p></div>'

describe 'SelectorBuilder class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'SelectorBuilder'
    setupFixture()

  describe 'has a constructor that', ->

    it 'requires one parameter', ->
      expect(@klass).to.have.length 1

    it 'defaults to setting the baseSelector property to "#content"', ->
      obj = new @klass()
      expect(obj.baseSelector).to.be '#content'

  describe 'has a "selectorFor" method that', ->

    beforeEach ->
      @obj = new @klass()

    it 'returns the correct selector for an existing child element', ->
      existing = $('#content p > em')
      expected = 'p:nth-child(1) > em:nth-child(1)'
      expect(@obj.selectorFor existing).to.be expected

    it 'returns an empty string for a non-existent child element', ->
      nonexistent = $('#content p > strong')
      expect(@obj.selectorFor nonexistent).to.be.empty()
