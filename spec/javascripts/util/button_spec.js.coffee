
#= require util/gateway

describe 'UtilButton class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'UtilButton'

  describe 'has an API including', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'an "HTML" method which takes one parameter', ->
      obj = new @klass()
      expect(obj.html).to.be.a 'function'
      expect(obj.html).to.have.length 1

  describe 'has properties set by the constructor, including', ->

    beforeEach ->
      @obj = new @klass()

    describe '"attrs", which', ->

      beforeEach ->
        @attrs = @obj.attrs

      it 'is an object hash', ->
        expect(@attrs).to.be.an 'object'

      it 'contains a "type" with the value "button"', ->
        expect(@attrs.type).to.be 'button'

    describe '"classes", which', ->

      beforeEach ->
        @classes = @obj.classes

      it 'is an array', ->
        expect(@classes).to.be.an Array

      it 'contains the item "button"', ->
        expect(@classes.indexOf 'button').to.not.be -1

  describe 'has an "html" method which', ->

    beforeEach ->
      markup = new @klass().html()
      @htmlObj = $(markup).get(0)

    it 'can be called with a default parameter', ->
      expect(=> new @klass().html()).to.not.throwError()

    describe 'returns markup for', ->

      it 'an HTMLButtonElement DOM element', ->
        expect(@htmlObj).to.be.a HTMLButtonElement

      it 'a "button" class', ->
        expect(@htmlObj.classList).to.contain 'button'

      it 'no other classes', ->
        expect(@htmlObj.classList).to.have.length 1

    describe 'by default, returns markup containing', ->

      it 'inner HTML of "BUTTON?!?"', ->
        expect(@htmlObj.innerHTML).to.be 'BUTTON?!?'

    it 'when called with a parameter value, returns that as the inner HTML', ->
      value = 'Push Me'
      markup = new @klass().html(value)
      htmlObj = $(markup).get(0)
      expect(htmlObj.innerHTML).to.be value
