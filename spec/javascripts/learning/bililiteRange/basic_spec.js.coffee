
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

      # Not testing using all() with parameter, which changes the content to the
      # passed-in text without changing the selection bounds. See
      # https://github.com/dwachss/bililiteRange/blob/master/bililiteRange.js#L203-L207
      # for details.

      it '"length"', ->
        expect(@func(@el).length()).to == @el.innerText.length

      describe '"bounds", which', ->

        describe 'when called with no arguments', ->

          beforeEach ->
            @bounds = @func(@el).bounds()

          it 'returns a two-element array', ->
            expect(@bounds).to.be.an 'array'
            expect(@bounds).to.have.length 2

          it 'has a first element value not less than zero', ->
            expect(@bounds[0]).to.be.a 'number'
            expect(@bounds[0]).to.be >= 0

          it 'has a last element value not greater than the element length', ->
            expect(@bounds[1]).to.be.a 'number'
            expect(@bounds[1]).to.be <= @el.innerText.length

        describe 'when called with a two-element array of indexes', ->
          beforeEach ->
            @ret = @func(@el).bounds([8, 16])

          it 'returns a W3CRange object with the specified bounds', ->
            expect(@ret.bounds()).to == [8, 16]

          it 'can be used to select the expected text', ->
            expect(@ret.select().selection()).to.be 'ordinary'

        describe 'when called with the argument "all"', ->

          beforeEach ->
            @ret = @func(@el).bounds('all')

          description = 'returns a W3CRange object whose bounds() method' +
              ' returns a 2-element array with'
          describe description, ->

            it 'a first value of zero', ->
              expect(@ret.bounds()[0]).to.be 0

            it 'a second value of the length of the element text', ->
              expect(@ret.bounds()[1]).to.be @el.innerText.length

        describe 'when called with the argument "selection"', ->

          beforeEach ->
            @el.focus()
            @node = @func(@el)
            @sel1 = @node.bounds([8, 16]).select()
            @sel = @node.bounds('selection')

          it 'returns the same W3Range object as from .select()', ->
            expect(@sel1).to == @sel

          it 'contains the expected text', ->
            expect(@sel.selection()).to == 'ordinary'
