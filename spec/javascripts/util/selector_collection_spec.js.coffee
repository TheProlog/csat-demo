
#= require util/gateway 

setup_fixture = ->
  html = '<div id="content">' +
      '<p>This is a test.</p><p>This is <em>another</em> test.</p>' +
      '</div>'
  fixture.set html

describe 'SelectorCollection class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'SelectorCollection'
    @base_selector = '#content'
    setup_fixture()

  describe 'has an API that includes', ->

    it 'a constructor taking one parameter', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 1

    it 'a "collection" method taking no parameters', ->
      obj = new @klass @base_selector
      expect(obj.collection).to.be.a 'function'
      expect(obj.collection).to.have.length 0

  describe 'when the constructor is passed an invalid selector', ->

    beforeEach ->
      @obj = new @klass '.bogus_selector'

    it 'it returns an empty array from the "collection" method', ->
      expect(@obj.collection()).to.be.empty()

  describe 'when constructed with a valid selector, "collection" returns', ->

    beforeEach ->
      @obj = new @klass @base_selector

    it 'an array with all valid child selectors, relative to the base', ->
      expected = [
        'p:nth-child(1)',
        'p:nth-child(2)',
        'p:nth-child(2) > em:nth-child(1)'
      ]
      expect(@obj.collection()).to == expected

