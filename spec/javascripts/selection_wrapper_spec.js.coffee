
#= require util/gateway

setupFixture = ->
  content_para = '<p>This is a test. <em>This is only a test.</em> That ' +
    'is all.</p>'

  base_div = [
    '<div id="base"><div id="content">',
    '</div></div>'].
    join content_para + '<div id="other"><p>This is <em>something</em>' +
        ' else. <span>And <em>this</em> is <em>something</em> yet again.' +
        '</span></p></div>'
  fixture.set base_div

describe 'SelectionWrapper class', ->

  beforeEach ->
    setupFixture()
    @klass = window.meldd_gateway.use 'SelectionWrapper'
    @top_selector = '#content'

  describe 'can be instantiated with', ->

    it 'no parameters', ->
      expect(new @klass()).to.be.an 'object'

    it 'one parameter, the selector of the container', ->
      expect(new @klass(@top_selector)).to.be.an 'object'

  describe 'after calling the constructor', ->

    # NOTE: This **must** be the first child "describe" group of its parent, or
    #       *Very* Bad Things™ **will** happen. See the note for the last spec
    #       for details.
    describe 'with no selection defined', ->

      beforeEach ->
        $.Range.current().range.detach()
        @obj = new @klass()

      describe 'the "start" property', ->

        it 'has a selector() value of "p:nth-child(1)"', ->
          expect(@obj.start.selector()).to.be 'p:nth-child(1)'

        it 'has a nodeIndex() value of 0', ->
          expect(@obj.start.nodeIndex()).to.be 0

        it 'has a textOffset() value of 0', ->
          expect(@obj.start.textOffset()).to.be 0

        it 'has the same values as the "end" property', ->
          expect(@obj.start.baseSelector).to.be @obj.end.baseSelector
          expect(@obj.start.offset).to.be @obj.end.offset
          expect(@obj.start.endpoint).to.be @obj.end.endpoint

      describe 'the "end" property', ->

        it 'has a selector() value of "p:nth-child(1)"', ->
          expect(@obj.end.selector()).to.be 'p:nth-child(1)'

        it 'has a nodeIndex() value of 0', ->
          expect(@obj.end.nodeIndex()).to.be 0

        it 'has a textOffset() value of 0', ->
          expect(@obj.end.textOffset()).to.be 0

        it 'has the same values as the "start" property', ->
          expect(@obj.start.baseSelector).to.be @obj.end.baseSelector
          expect(@obj.start.offset).to.be @obj.end.offset
          expect(@obj.start.endpoint).to.be @obj.end.endpoint

      description = 'the "parent" property is a/the Document node ' +
          '| <strong>DEFERRED</strong> due to environmental conditions:' +
          ' see notes in spec'
      xit description, ->
        # NOTE: DANGER, WILL ROBINSON, EXTREME DANGER! This spec will exhibit
        #       *varying* behaviour when run individually than when run as part
        #       of the run-all-specs task IF AND ONLY IF the 'with no selection
        #       defined' "describe" block occurs AFTER the 'with a selection
        #       defined' block. It seems as though the DOM reinitialisation done
        #       by the Selenium web driver isn't as complete or reliable as it
        #       *should* be.
        #
        #       It gets *worse*. The spec as currently written passes when
        #       Teaspoon is run from the command line; passes when the specs for
        #       SelectionWrapper (or any subset of them) are run from the
        #       browser, but *fails* when *all* specs are run from the browser.
        #       I give up. Note that this *still* runs properly in the original
        #       `selection_demo` project specs.
        expect(@obj.parent.nodeType).to.be Node.DOCUMENT_NODE

    # NOTE: This **must** be **after** the 'with no selection defined' group
    #       above. Failure to do so will cause breakage having *nothing to do
    #       with* the underlying code being tested. See the NOTE in the last
    #       spec in the preceding group for details.
    describe 'with a selection defined', ->

      beforeEach ->
        $(@top_selector).selection 31, 41
        @obj = new @klass()

      afterEach ->
        $(@top_selector).selection 0, 0

      describe 'an Endpoint instance is assigned to the attribute', ->

        afterEach ->
          expect(@obj[@prop]).to.be.an 'object'
          endpoint = @obj[@prop]
          for method in ['nodeIndex', 'selector', 'textOffset']
            expect(endpoint[method]).to.be.a 'function'

        it '"start"', ->
          @prop = 'start'

        it '"end"', ->
          @prop = 'end'

      it 'the "parent" property is set to a DOM Element', ->
        expect(@obj.parent).to.be.an 'object'
        expect(@obj.parent.nodeType).to.be Node.ELEMENT_NODE

  describe 'includes Law-of-Demeter mitigation methods, including', ->

    describe 'a startSelector method that returns the', ->

      it 'endpoint selector value when a selection is defined', ->
        $(@top_selector).selection 31, 41
        expected = 'p:nth-child(1) > em:nth-child(1)'
        expect(new @klass().startSelector()).to.be expected

      it 'first element selector when no selection is defined', ->
        expect(new @klass().startSelector()).to.be 'p:nth-child(1)'

    describe 'an endSelector method that returns the', ->

      it 'endpoint selector value when a selection is defined', ->
        $(@top_selector).selection 31, 41
        expected = 'p:nth-child(1)'
        expect(new @klass().endSelector()).to.be expected

      it 'first element selector when no selection is defined', ->
        expect(new @klass().endSelector()).to.be 'p:nth-child(1)'

    describe 'a startNodeIndex method that returns', ->

      it 'the start endpoint child node index when a selection is defined', ->
        $(@top_selector).selection 66, 71
        expected = 2
        expect(new @klass().startNodeIndex()).to.be expected

      it 'a value of zero when no selection is defined', ->
        expect(new @klass().startNodeIndex()).to.be 0

    describe 'an endNodeIndex method that returns', ->

      it 'the end endpoint child node index when a selection is deined', ->
        $(@top_selector).selection 66, 71
        expected = 2
        expect(new @klass().endNodeIndex()).to.be expected

      it 'a value of zero when no selection is defined', ->
        expect(new @klass().endNodeIndex()).to.be 0

    describe 'a startOffset method that returns', ->

      it 'the start endpoint text-node offset when a selection is defined', ->
        $(@top_selector).selection 67, 71
        expect(new @klass().startOffset()).to.be 1

      it 'a value of zero when no selection is defined', ->
        expect(new @klass().startOffset()).to.be 0

    describe 'an endOffset method that returns', ->

      it 'the end endpoint text node offset when a selection is defined', ->
        $(@top_selector).selection 67, 71
        expect(new @klass().endOffset()).to.be 5

      it 'a value of zero when no selection is defined', ->
        expect(new @klass().endOffset()).to.be 0

  describe 'has all initialisation scenarios as expected, including where', ->

    describe 'both endpoints identify', ->

      sameEnds = 'the start and end values are the same for'
      describe 'the same point: ' + sameEnds, ->

        beforeEach ->
          $(@top_selector).selection 67, 67
          @obj = new @klass()

        it 'selector', ->
          expect(@obj.startSelector()).to.be @obj.endSelector()

        it 'node index', ->
          expect(@obj.startNodeIndex()).to.be @obj.endNodeIndex()

        it 'text offset', ->
          expect(@obj.startOffset()).to.be @obj.endOffset()

      describe 'positions within', ->

        describe 'the same text node within the same element', ->

          beforeEach ->
            $(@top_selector).selection 67, 68
            @obj = new @klass()

          describe sameEnds, ->

            it 'selector', ->
              expect(@obj.startSelector()).to.be @obj.endSelector()

            it 'node index', ->
              expect(@obj.startNodeIndex()).to.be @obj.endNodeIndex()

          it 'the starting offset and ending offset are different', ->
            expect(@obj.startOffset()).not.to.be @obj.endOffset()

        describe 'consecutive text nodes within the same element', ->

          beforeEach ->
            $(@top_selector).selection 55, 70
            @obj = new @klass()

          describe sameEnds, ->

            it 'selector', ->
              expect(@obj.startSelector()).to.be @obj.endSelector()

          describe 'different values for', ->

            it 'node index', ->
              expect(@obj.startNodeIndex() + 2).to.be @obj.endNodeIndex()

            it 'text offset', ->
              expect(@obj.startOffset()).not.to.be @obj.endOffset()

        describe 'non-consecutive text nodes within the same element', ->

          beforeEach ->
            $(@top_selector).selection 75, 98
            @obj = new @klass()

          describe sameEnds, ->

            it 'selector', ->
              expect(@obj.startSelector()).to.be @obj.endSelector()

          describe 'different values for', ->

            it 'node index', ->
              expect(@obj.endNodeIndex() - @obj.startNodeIndex()).to.be.
                  greaterThan 2

            it 'text offset', ->
              expect(@obj.startOffset()).not.to.be @obj.endOffset()


    describe 'the end element is', ->

      description = 'the immediate next child node of the start element ' +
          'after the start point'
      describe description, ->

        beforeEach ->
          $(@top_selector).selection 54, 61
          @obj = new @klass()

        description = 'it has selector values reflecting the endpoint as' +
            ' child of the starting point,'
        describe description, ->

          beforeEach ->
            @startSel = @obj.startSelector()
            @endSel = @obj.endSelector()
            @slice = @endSel.slice 0, @startSel.length

          description = 'with the start selector being a substring of the' +
              ' end selector'
          it description, ->
            expect(@startSel).to.be @slice

          it 'with the end selector being longer/deeper than the start', ->
            expect(@endSel.length).to.be.greaterThan @startSel.length

      describe 'a direct child of the start element,', ->

        beforeEach ->
          $(@top_selector).selection 54, 61
          @obj = new @klass()

        description = 'it has an end selector specifying a direct child of' +
            ' the start point, '
        it description, ->
          startObj = $(@top_selector).find(@obj.startSelector())
          endObj = $(@top_selector).find(@obj.endSelector())
          expect(endObj.parent().is startObj).to.be true  # ask jQuery

      describe 'an indirect child of the start element,', ->

        beforeEach ->
          $(@top_selector).selection 54, 80
          @obj = new @klass()

        description = 'it has an end selector specifying a child of the start' +
            ' point, such that'
        describe description, ->

          beforeEach ->
            @startSel = @obj.startSelector()
            @endSel = @obj.endSelector()
            @slice = @endSel.slice 0, @startSel.length

          description = 'with the start selector being a substring of the' +
              ' end selector'
          it description, ->
            expect(@startSel).to.be @slice

          it 'with the end selector being longer/deeper than the start', ->
            expect(@endSel.length).to.be.greaterThan @startSel.length

        it 'it is not a direct child of the start point', ->
          startObj = $(@top_selector).find(@obj.startSelector())
          endObj = $(@top_selector).find(@obj.endSelector())
          expect(endObj.parent().is startObj).to.be false  # ask jQuery

      describe 'the last child element of the start element,', ->

        beforeEach ->
          $(@top_selector).selection 0, 24
          @obj = new @klass()

        it 'the end element has no next element sibling', ->
          endEl = $(@obj.endSelector()).get(0)
          expect(endEl.nextElementSibling).to.be null

        it 'the end element is a child of the start element', ->
          endEl = $(@obj.endSelector()).get(0)
          startEl = $(@obj.startSelector()).get(0)
          expect(startEl.contains endEl).to.be true
          expect(startEl).not.to.be endEl

      description = 'a child element not the last child element of the start' +
          ' element'
      describe description, ->

        beforeEach ->
          $(@top_selector).selection 50, 60
          @obj = new @klass()

        it 'the end element has a next element sibling', ->
          endEl = $(@obj.endSelector()).get(0)
          expect(endEl.nextElementSibling).not.to.be null

        it 'the end element is a child of the start element', ->
          endEl = $(@obj.endSelector()).get(0)
          startEl = $(@obj.startSelector()).get(0)
          expect(startEl.contains endEl).to.be true
          expect(startEl).not.to.be endEl

    describe 'the start element is', ->

      description = 'the immediate previous child node of the end element ' +
          'before the end point;'
      describe description, ->

        beforeEach ->
          $(@top_selector).selection 30, 41
          @obj = new @klass()
          @startEl = $(@obj.startSelector()).get(0)
          @endEl = $(@obj.endSelector()).get(0)

        it 'the end element contains the starting element', ->
          expect(@endEl.contains @startEl).to.be true

        it 'the end element is not the starting element', ->
          expect(@startEl).not.to.be @endEl

        description = 'the start element is the immediate previous child node' +
            ' of the end element before the end point.'
        it description, ->
          expect(@startEl.lastChild).to.
              be @endEl.childNodes[@obj.endNodeIndex() - 1].lastChild

      it 'a direct child of the end element', ->
        $(@top_selector).selection 31, 40
        obj = new @klass()
        startEl = $(obj.startSelector()).get(0)
        endEl = $(obj.endSelector()).get(0)
        expect(startEl.parentElement).to.be endEl

      it 'an indirect child of the end element', ->
        fixture.set '<div id="base"><div id="content">' +
            '<p>This <span><em>is</em> a</span> test.</p>' +
            '</div></div>'
        $(@top_selector).selection 6, 14
        obj = new @klass()
        startEl = $(obj.startSelector()).get(0)
        endEl = $(obj.endSelector()).get(0)
        expect(endEl.contains startEl).to.be true
        expect(startEl.parentElement).not.to.be endEl

      it 'the first child element of the end element', ->
        fixture.set '<div id="base"><div id="content">' +
            '<p>This <span>is</span> <span>a</span> test.</p>' +
            '</div></div>'
        $(@top_selector).selection 6, 14
        obj = new @klass()
        startEl = $(obj.startSelector()).get(0)
        endEl = $(obj.endSelector()).get(0)
        expect(startEl).to.be endEl.children[0]

      it 'a child element not the first child element of the end element', ->
        fixture.set '<div id="base"><div id="content">' +
            '<p>This <span>is</span> <span>a</span> test.</p>' +
            '</div></div>'
        $(@top_selector).selection 8, 14
        obj = new @klass()
        startEl = $(obj.startSelector()).get(0)
        endEl = $(obj.endSelector()).get(0)
        expect(startEl).to.be endEl.children[1]

    describe 'the start and end elements are', ->

      describe 'immediate child elements of a common parent element', ->

        beforeEach ->
          fixture.set '<div id="base"><div id="content">' +
              '<p id="p1">This is the first test.</p>' +
              '<p id="p2">This is the second test.</p>'
              '</div></div>'
          $(@top_selector).selection 13, 31
          @obj = new @klass()

        describe 'has different start and end selector values, namely', ->

          it 'the start element is the first paragraph', ->
            expect(@obj.startSelector()).to.be 'p:nth-child(1)'

          it 'the end element is the second paragraph', ->
            expect(@obj.endSelector()).to.be 'p:nth-child(2)'

      describe 'indirect child elements of a common parent,', ->

        describe 'nested at the same level with respect to that parent', ->

          beforeEach ->
            fixture.set '<div id="base"><div id="content">' +
                '<div id="foo"><p id="p1">This is the first test.</p></div>' +
                '<div id="bar"><p id="p2">This is the second test.</p></div>'
                '</div></div>'
            $(@top_selector).selection 13, 31
            @obj = new @klass()

          describe 'has different start and end selector values, namely', ->

            it 'the start element is the first paragraph in the first div', ->
              expected = 'div:nth-child(1) > p:nth-child(1)'
              expect(@obj.startSelector()).to.be expected

            it 'the end element is the first paragraph in the second div', ->
              expected = 'div:nth-child(2) > p:nth-child(1)'
              expect(@obj.endSelector()).to.be expected

        description = 'where the start element is the more deeply-nested of' +
            ' the two'
        describe description, ->

          beforeEach ->
            fixture.set '<div id="base"><div id="content">' +
                '<div id="foo"><p id="p1">This is the first test.</p></div>' +
                '<p id="p2">This is the second test.</p>'
                '</div></div>'
            $(@top_selector).selection 13, 31
            @obj = new @klass()

          describe 'has different start and end selector values, namely', ->

            it 'the start element is the first paragraph in the first div', ->
              expected = 'div:nth-child(1) > p:nth-child(1)'
              expect(@obj.startSelector()).to.be expected

            description = 'the end element is the paragraph that is the' +
                ' second child of the #content div'
            it description, ->
              expected = 'p:nth-child(2)'
              expect(@obj.endSelector()).to.be expected

        description = 'where the end element is the more deeply-nested of ' +
            'the two'
        describe description, ->

          beforeEach ->
            fixture.set '<div id="base"><div id="content">' +
                '<p id="p1">This is the first test.</p>' +
                '<div id="bar"><p id="p2">This is the second test.</p></div>'
                '</div></div>'
            $(@top_selector).selection 13, 31
            @obj = new @klass()

          describe 'has different start and end selector values, namely', ->

            it 'the start element is the first paragraph', ->
              expected = 'p:nth-child(1)'
              expect(@obj.startSelector()).to.be expected

            description = 'the end element is the first paragraph in the div' +
                ' that is the second child of the content area'
            it description, ->
              expected = 'div:nth-child(2) > p:nth-child(1)'
              expect(@obj.endSelector()).to.be expected
