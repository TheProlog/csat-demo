
#= require util/gateway

# Rant is re what's been shoved down to 'CsatVhDummiedForm'. Go read it.
#
# This STINKS. ~55 lines of crapola that recreates an *entire* *bloody* *form*
# in all its guts and vainglory, just so the spec for CsatVolueHarvester can
# point its subject at markup to scrape. Cluttering the public API with wrappers
# for `$(@baseSelector).find($(itemSelector).val())` and
# `$(itemSelector).val().toNumber()` seems stupid (read as: down on our knees
# begging for trouble), but we need a better way to test stuff like this. Maybe
# a `params` hash to the constructor with optional replacements for internal
# functions that wrap those two bits of jQuery code. Something. Anything. Just
# put this out of our misery!

setupFixture = ->
  dummiedForm = window.meldd_gateway.use 'CsatVhDummiedForm'
  fixture.set dummiedForm() + '<div class="boilerplate"></div>'
  options = [
    'h1:nth-child(1)',
    'p:nth-child(2)',
    'p:nth-child(2) em:nth-child(1)',
    'p:nth-child(2) strong:nth-child(2)',
    'h2:nth-child(3)',
    'p:nth-child(4)',
    'ul:nth-child(5)',
    'ul_nth-child(5) li:nth-child(1)',
    'ul_nth-child(5) li:nth-child(2)',
    'ul_nth-child(5) li:nth-child(3)',
    'ul_nth-child(5) li:nth-child(4)'
  ]
  for option in options
    $('#start_selector').append($('<option>').text(option))
    $('#end_selector').append($('<option>').text(option))

setupSelection = (startSelector, startIndex, startOffset,
    endSelector, endIndex, endOffset) ->
  $('#start_selector').select startSelector
  $('#end_selector').select endSelector
  $('#start_nodeindex').val startIndex.toString()
  $('#end_nodeindex').val endIndex.toString()
  $('#start_textoffset').val startOffset.toString()
  $('#end_textoffset').val endOffset.toString()

describeFunctionProperty = (funcName) ->
  description = 'sets the value of the "{1}" property so that it'
  describe description.assign(funcName), ->

    it 'by default is a function taking two parameters', ->
      obj = new @klass()
      func = obj[funcName]
      expect(func).to.be.a 'function'
      expect(func).to.have.length 2

    it 'can be specified by an item in the params hash', ->
      newFunc = (p1, p2) -> 'bingo';
      params = {}
      params[funcName] = newFunc
      obj = new @klass(params)
      func = obj[funcName]
      expect(func).to.be newFunc


matchValuesPart = (part, selector, nodeIndex, offset) ->
  it part, ->
    obj = @values[part]
    expect(obj.baseSelector).to.be '.boilerplate'
    expect(obj.nodeIndex).to.be nodeIndex
    expect(obj.offset).to.be offset
    expect(obj.selector.jquery).to.match /1.\d+.\d+/
    expect(obj.selector.selector).to.be '.boilerplate ' + selector

## ########################################################################### ##
## ########################################################################### ##
## ########################################################################### ##
## ########################################################################### ##

describe 'CsatValueHarvester class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CsatValueHarvester'
    setupFixture()

  describe 'has a public API including', ->

    describe 'a constructor that', ->

      it 'takes one parameter', ->
        expect(@klass).to.be.a 'function'
        expect(@klass).to.have.length 1

      it 'may be called using a default parameter', ->
        expect(=> new @klass()).to.not.throwError()

    it 'a "values" method that takes no parameters', ->
      obj = new @klass()
      expect(obj.values).to.be.a 'function'
      expect(obj.values).to.have.length 0

  describe 'has a constructor that', ->

    description = 'sets the value of the "{1}" property to'
    describe description.assign('baseSelector'), ->

      it '".boilerplate" by default', ->
        obj = new @klass()
        expect(obj.baseSelector).to.be '.boilerplate'

      it 'an explicit value passed in the params hash', ->
        expected = 'anything at all'
        obj = new @klass({baseSelector: expected})
        expect(obj.baseSelector).to.be expected

    describeFunctionProperty.call @, 'findSelectedElementFor'
    describeFunctionProperty.call @, 'getIntegerValueForField'

  describe 'has a "values" method that returns', ->

    describe 'an object hash that itself contains object hashes for', ->

      beforeEach ->
        selector = 'h1:nth-child(1)'
        $('.boilerplate').html('<h1>This is a test.</h1>')
        setupSelection(selector, 0, 0, selector, 0, 4)
        @values = new @klass().values()

      it 'start', ->
        expect(@values.start).to.be.an 'object'

      it 'end', ->
        expect(@values.start).to.be.an 'object'

    describe 'correct values for form selection where the selection is', ->

      describe 'within a single text node in a single element, including', ->

        beforeEach ->
          selector = 'h1:nth-child(1)'
          $('.boilerplate').html('<h1>This is a test.</h1>')
          setupSelection(selector, 0, 0, selector, 0, 4)
          @values = new @klass().values()

        matchValuesPart.call @, 'start', 'h1:nth-child(1)', 0, 0
        matchValuesPart.call @, 'end', 'h1:nth-child(1)', 0, 4

      describe 'across multiple text nodes within a single element', ->

        beforeEach ->
          selector = 'h1:nth-child(1)'
          $('.boilerplate').html('<h1>This <i>is</i> a test.</h1>')
          setupSelection(selector, 0, 0, selector, 2, 3)
          @values = new @klass().values()

        matchValuesPart.call @, 'start', 'h1:nth-child(1)', 0, 0
        matchValuesPart.call @, 'end', 'h1:nth-child(1)', 2, 3

      describe 'across text nodes within separate elements', ->

        beforeEach ->
          html = '<h1>This <i>is</i> a test.</h1><p>More tests.</p>'
          $('.boilerplate').html(html)
          setupSelection('h1:nth-child(1)', 2, 1, 'p:nth-child(2)', 0, 4)
          @values = new @klass().values()

        matchValuesPart.call @, 'start', 'h1:nth-child(1)', 2, 1
        # matchValuesPart.call @, 'end', 'p:nth-child(2)', 0, 4
