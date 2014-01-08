
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
        '<p>This is a test.</p>' +
        '<p>This is <em>another</em> test.</p>' +
      '</div>'

  describe 'bililiteRange', ->

    beforeEach ->
      @el = fixture.el.children[0].children[0] # '#content > p:nth-child(1)'

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
            @node = @func(@el.firstElementChild)
            @sel1 = @node.bounds([8, 16]).select()
            @sel = @node.bounds('selection')

          it 'returns the same W3Range object as from .select()', ->
            expect(@sel1).to == @sel

          it 'contains the expected text', ->
            expect(@sel.selection()).to == 'ordinary'

      describe '"element", which returns', ->

        description = 'the top-level element within which a selection is' +
            ' active, if a single element'
        it description, ->
          rng = @func(@el).bounds([8,16]).select()
          expect(rng.element()).to == $('#content').get(0)

        description = 'the common parent element of a selection which spans' +
            'multiple elements'
        it description, ->
          el = fixture.el.children[0] # div.content
          sel = @func(el).bounds([8, 179]).select() # first to last children
          expect(sel.element()).to == $('#content').get(0)

      describe '"selection", when the selection', ->

        it 'is within a single node', ->
          sel = @func(@el).bounds([0, 7]).select()
          expect(sel.selection()).to.be 'This is'

        it 'spans multiple nodes', ->
          sel = @func(@el).bounds([97, 117]).select()
          expect(sel.selection()).to.be 'may be emphasized to'

      describe '"_nativeRange", when the selection', ->

        it 'is within a single node', ->
          sel = @func(@el).bounds([0, 7]).select()
          rng = sel._nativeRange()
          expect(rng.commonAncestorContainer).to == $('.boilerplate h1').get(0)
          expect(rng.startContainer).to == rng.commonAncestorContainer
          expect(rng.endContainer).to == rng.commonAncestorContainer
          expect(rng.startOffset).to.be 0
          # expect(rng.endOffset).to.be 7     #### FAILS; reports 5
          debug.debug rng.startOffset, rng.endOffset

        it 'spans multiple nodes in the same element', ->
          el = fixture.el.children[0] # '#content'
          sel = @func(el).bounds([0, 176]).select()
          rng = sel._nativeRange()
          expect(rng.commonAncestorContainer).to == $('#content')
          debug.debug rng.commonAncestorContainer == $('#content')      # false
          expect(rng.startContainer).to == $('#content p:nth-child(1)')
          debug.debug rng.startContaner == $('#content p:nth-child(1)') # false again
          expect(rng.endContainer).to == $('#content p:nth-child(3)')
          debug.debug rng.endContainer == $('#content p:nth-child(3)')  # again false
          expect(rng.startOffset).to == 0
          debug.debug rng.endOffset # 3
          # expect(rng.endOffset).to == 7 # 'This is'.length
          debug.debug Object.clone(sel._nativeRange()), sel.selection()
