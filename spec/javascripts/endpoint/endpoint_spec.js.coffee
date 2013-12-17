
#= require util/gateway

setupFixture = ->
  content_para = 'This is a test. <em>This is only a test.</em> That ' +
    'is all.'
  base_div = [
    '<div id="base"><div id="content"><p>',
    '</p></div></div>'].
    join content_para
  fixture.set base_div + '<div id="other"><p>This is something else.</p></div>'

describe 'Endpoint class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'Endpoint'
    setupFixture()

  describe 'has a constructor that', ->

    it 'takes three parameters', ->
      expect(@klass).to.have.length 3

    it 'may be successfully called with one parameter', ->
      expect(new @klass $('#content > p')).to.be.an 'object'

    describe 'uses an "endpointNode" parameter', ->

      beforeEach ->
        @param = $('#content > p')

      describe 'that may be a', ->

        afterEach ->
          obj = new @klass @param
          expect(obj).to.be.an 'object'

        it 'DOM Node', ->
          @param = @param.get(0).childNodes[0]

        it 'DOM Element', ->
          @param = @param.get(0)

        it 'jQuery object', ->
          @param = @param

      describe 'that is stored correctly when specified as a', ->

        afterEach ->
          obj = new @klass @param
          expect(obj.endpointNode?.nodeType).to.be Node.TEXT_NODE

        it 'DOM Node', ->
          @param = @param.get(0).childNodes[0]

        it 'DOM Element', ->
          @param = @param.get(0)

        it 'jQuery object', ->
          @param = @param

    describe 'uses an optional "offset" parameter', ->

      beforeEach ->
        @param = $('#content > p')
        @offset = 7

      it 'that accepts a numeric value', ->
        expect(new @klass @param, @offset).to.be.an 'object'

      describe 'that is stored correctly when specified', ->

        it 'as a legal integer value', ->
          obj = new @klass @param, @offset
          expect(obj.offset).to.be @offset

        it 'using the default value of 0', ->
          obj = new @klass @param
          expect(obj.offset).to.be 0

    describe 'uses an optional "baseSelector" parameter', ->
      beforeEach ->
        @param = $('#content > p')
        @offset = 7
        @selector = '.anything'

      it 'that accepts a string CSS/jQuery selector value', ->
        expect(new @klass @param, @offset, @selector).to.be.an 'object'

      describe 'that is stored correctly when specified', ->

        it 'explicitly', ->
          obj = new @klass @param, @offset, @selector
          expect(obj.baseSelector).to.be @selector

        it 'using the default value of "#content"', ->
          obj = new @klass @param, @offset
          expect(obj.baseSelector).to.be '#content'

  describe 'has a "selector" method that, for an endpoint within', ->

    afterEach ->
      obj = new @klass @param
      expect(obj.selector()).to.be @expected

    it 'the first text node of the first "p", returns "p:nth-child(1)"', ->
      @param = $('#content p')
      @expected = 'p:nth-child(1)'

    it 'the emphasised text, returns "p:nth-child(1) > em:nth-child(1)"', ->
      @param = $('#content p > em')
      @expected = 'p:nth-child(1) > em:nth-child(1)'

    it 'the last text node of the first "p", returns "p:nth-child(1)"', ->
      @param = $('#content > p').get(0).childNodes[2]
      @expected = 'p:nth-child(1)'

  describe 'has a "nodeIndex" method that', ->

    afterEach ->
      $('#content p').selection @selection.start, @selection.end
      start = $.Range.current().start()
      obj = new @klass start.container, start.offset
      expect(obj.nodeIndex()).to.be @expected

    it 'returns 0 when endpoint is in first child node of the element', ->
      @selection = {start: 5, end: 10}  # 'is a'
      @expected = 0

    it 'returns 2 when endpoint is in third child node of the element', ->
      @selection = {start: 37, end: 42} # 'That'
      @expected = 2

  describe 'has a "textOffset" method that', ->

    it 'returns the offset of the endpoint within its text node', ->
      $('#content p').selection 5, 10   # 'is a'
      start = $.Range.current().start()
      obj = new @klass start.container, start.offset
      expect(obj.textOffset()).to.be 5

  describe 'when no active selection (Card #12)', ->

    it 'has a defined object', ->
      obj = new @klass()
      expect(typeof(obj.endpointNode)).to.be 'object'

    it 'has the first content element as the "selector()" value', ->
      expect(new @klass().selector()).to.be 'p:nth-child(1)'

    it 'has the "nodeIndex()" value of 0', ->
      expect(new @klass().nodeIndex()).to.be 0

    it 'has the "textOffset()" value of 0', ->
      expect(new @klass().textOffset()).to.be 0

  describe 'has a "sameNodeAs" method that', ->

    it 'returns "false" when passed a non-Endpoint parameter', ->
      obj = new @klass()
      expect(obj.sameNodeAs($.Range.current())).to.be false

    it 'returns "true" when passed an Endpoint in the same text node', ->
      $('#content p').selection 5, 10
      start = $.Range.current().start()
      end = $.Range.current().end()
      obj1 = new @klass start.container, start.offset
      obj2 = new @klass end.container, end.offset
      expect(obj1.sameNodeAs(obj2)).to.be true

    it 'returns "false" when passed an Endpoint in a different text node', ->
      $('#content p').selection 5, 25
      start = $.Range.current().start()
      end = $.Range.current().end()
      obj1 = new @klass start.container, start.offset
      obj2 = new @klass end.container, end.offset
      expect(obj1.sameNodeAs(obj2)).to.be false

  describe 'has a "containsElementFor" method that', ->

    it 'returns "false" when passed an invalid parameter', ->
      expect(new @klass().containsElementFor "bogus").to.be false

    it 'returns "true" when passed a child-element node', ->
      $('#content p').selection 5, 25
      start = $.Range.current().start()
      end = $.Range.current().end()
      obj1 = new @klass start.container, start.offset
      obj2 = new @klass end.container, end.offset
      expect(obj1.containsElementFor(obj2)).to.be true

    it 'returns "false" when passed a non-child-element node', ->
      $('#content p').selection 5, 25
      start = $.Range.current().start()
      end = $.Range.current().end()
      obj1 = new @klass start.container, start.offset
      obj2 = new @klass end.container, end.offset
      expect(obj2.containsElementFor(obj1)).to.be false
