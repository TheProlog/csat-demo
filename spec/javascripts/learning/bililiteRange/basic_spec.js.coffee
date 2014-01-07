
#= require 'spec_helper'
#= require bililiteRange

describe 'Learning bililiteRange', ->

  beforeEach ->
    @func = bililiteRange
    fixture.set '<div id="content">' +
      '<p>' +
        'This is ordinary paragraph text within the body of the document,' +
        ' where certain words and phrases may be <em>emphasized</em> to mark' +
        ' them as <strong>particularly important</strong>.' +
        '</p>' +
      '</div>'

  describe 'bililiteRange', ->

    beforeEach ->
      @el = fixture.el.children[0]

    it 'is a function with two parameters', ->
      expect(@func).to.be.a 'function'
      expect(@func).to.have.length 2

    it 'can be called with a single parameter', ->
      expect(=> @func(@el)).not.to.throwError()

    it 'can be called with a DOM element as a parameter', ->
      expect(@func @el).to.be.an 'object'

    it 'by default, sets the range to the entire element text', ->
      expect(@func(@el).bounds()).to == [0, @el.innerText.length]

    describe 'returns an object with methods including', ->

      it '"all"', ->
        expect(@func(@el).all()).to == fixture.el.innerText
