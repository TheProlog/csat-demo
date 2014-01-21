
#= require util/gateway

########################### HELPER/INTERNAL FUNCTIONS ###########################

## Builders (1 of 4) ##############################

build_instance = (klass, params_in = {}) ->
  new klass(params_in)

buildValuesForInstanceWith = (klass, elementFor, valueFor) ->
  params = {
    findSelectedElementFor: elementFor
    getIntegerValueForField: valueFor
  }
  build_instance(klass, params).values()

## Symbolic Data (2 of 4) #########################

firstElement = 'h1:nth-child(1)'

secondElement = 'p:nth-child(2)'

## ValueHarvester method variables (3 of 4) #######

inSameElement = (params...) ->
  firstElement

inDifferentElements = (baseSelector, selector) ->
  if selector.match /#start_selector/
    firstElement
  else
    secondElement

inSameNode = (whichEnd, field) ->
  if whichEnd == 'end' && field == 'textoffset' then 4 else 0

inDifferentNodes = (whichEnd, field) ->
  {
    start:  {nodeindex: 0, textoffset: 0},
    end:    {nodeindex: 2, textoffset: 3}
  }[whichEnd][field]

nodesInDifferentElements = (whichEnd, field) ->
  {
    start:  {nodeindex: 2, textoffset: 1},
    end:    {nodeindex: 0, textoffset: 4}
  }[whichEnd][field]

## "Shared Specs" (4 of 4) ########################

describeFunctionProperty = (funcName) ->
  description = 'sets the value of the "{1}" property so that it'
  describe description.assign(funcName), ->

    it 'by default is a function taking two parameters', ->
      obj = build_instance @klass
      func = obj[funcName]
      expect(func).to.be.a 'function'
      expect(func).to.have.length 2

    it 'can be specified by an item in the params hash', ->
      newFunc = (p1, p2) -> 'bingo';
      params = {}
      params[funcName] = newFunc
      obj = build_instance @klass, params
      func = obj[funcName]
      expect(func).to.be newFunc

matchValuesPart = (part, selector, nodeIndex, offset) ->
  it part, ->
    obj = @values[part]
    expect(obj.baseSelector).to.be '.boilerplate'
    expect(obj.nodeIndex).to.be nodeIndex
    expect(obj.offset).to.be offset

## ########################################################################### ##
## ########################################################################### ##
## ########################################################################### ##
## ########################################################################### ##

describe 'CsatValueHarvester class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'CsatValueHarvester'

  describe 'has a public API including', ->

    describe 'a constructor that', ->

      it 'takes one parameter', ->
        expect(@klass).to.be.a 'function'
        expect(@klass).to.have.length 1

      it 'may be called using a default parameter', ->
        expect(=> build_instance @klass).to.not.throwError()

    it 'a "values" method that takes no parameters', ->
      obj = build_instance @klass
      expect(obj.values).to.be.a 'function'
      expect(obj.values).to.have.length 0

  describe 'has a constructor that', ->

    description = 'sets the value of the "{1}" property to'
    describe description.assign('baseSelector'), ->

      it '".boilerplate" by default', ->
        obj = build_instance @klass
        expect(obj.baseSelector).to.be '.boilerplate'

      it 'an explicit value passed in the params hash', ->
        expected = 'anything at all'
        obj = build_instance @klass, {baseSelector: expected}
        expect(obj.baseSelector).to.be expected

    describeFunctionProperty.call @, 'findSelectedElementFor'
    describeFunctionProperty.call @, 'getIntegerValueForField'

  describe 'has a "values" method that returns', ->

    describe 'an object hash that itself contains object hashes for', ->

      beforeEach ->
        findSelectedElementFor = inSameElement  # or anything at all, really
        getIntegerValueForField = inSameNode
        params = {findSelectedElementFor, getIntegerValueForField}
        @values = build_instance(@klass, params).values()

      it 'start', ->
        expect(@values.start).to.be.an 'object'

      it 'end', ->
        expect(@values.end).to.be.an 'object'

    describe 'correct values for form selection where the selection is', ->

      describe 'within a single text node in a single element, including', ->

        beforeEach ->
          @values = buildValuesForInstanceWith @klass, inSameElement, inSameNode

        matchValuesPart.call @, 'start',  firstElement, 0, 0
        matchValuesPart.call @, 'end',    firstElement, 0, 4

      describe 'across multiple text nodes within a single element', ->

        beforeEach ->
          @values = buildValuesForInstanceWith @klass, inSameElement,
              inDifferentNodes

        matchValuesPart.call @, 'start',  firstElement, 0, 0
        matchValuesPart.call @, 'end',    firstElement, 2, 3

      describe 'across text nodes within separate elements', ->

        beforeEach ->
          @values = buildValuesForInstanceWith @klass, inDifferentElements,
              nodesInDifferentElements

        matchValuesPart.call @, 'start',  firstElement,   2, 1
        matchValuesPart.call @, 'end',    secondElement,  0, 4
