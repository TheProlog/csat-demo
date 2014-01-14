
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

verifyMethodApi = (obj, method, length) ->
  expect(obj[method]).to.be.a 'function'
  expect(obj[method]).to.have.length length

describe 'ContentSelection class', ->

  beforeEach ->
    setupFixture()
    @klass = window.meldd_gateway.use 'ContentSelection'

  describe 'has an API with a', ->

    it 'constructor which takes one parameter', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 1

    it 'setStart method that takes three parameters', ->
      verifyMethodApi(new @klass('#content'), 'setStart', 3)

    it 'setEnd method that takes three parameters', ->
      verifyMethodApi(new @klass('#content'), 'setEnd', 3)

    it 'getContent method that takes no parameters', ->
      verifyMethodApi(new @klass('#content'), 'getContent', 0)

  describe 'has a constructor that', ->

    description = 'sets the "baseSelector" property to the parameter value if' +
        ' the parameter identifies an existing container'
    it description, ->
      obj = new @klass('#content')
      # expect(obj.baseSelector).to == 'anything at all'  # always true; why?!?
      expect(obj.baseSelector == '#content').to.be true

    describe 'raises an error when', ->

      it 'the parameter does not identify an existing selector', ->
        expect(=> new @klass('#bogus')).to.throwError((e) ->
          message = 'ContentSelection constructor was passed an invalid selector.'
          expect(e.message).to.be message
        )

      it 'no parameter was specified', ->
        expect(=> new @klass()).to.throwError((e) ->
          message = 'ContentSelection constructor requires a parameter.'
          expect(e.message).to.be message
        )

  describe 'has a setStart method that', ->

    description = 'sets the "startSelector" property to the first parameter' +
        ' value if it is a valid selector'
    it description, ->
      obj = new @klass('#content')
      startSelector = 'p:nth-child(1)'
      obj.setStart(startSelector, 0, 0)
      # WTF: Normal expect doesn't work for strings; does work for integers.
      expect(obj.startSelector == startSelector).to.be true

    description = 'sets the "startNodeIndex" property to the second parameter' +
        ' value if it is a valid node index for @startElement'
    it description, ->
      obj = new @klass('#content')
      startNodeIndex = 2
      obj.setStart('p:nth-child(1)', startNodeIndex, 0)
      expect(obj.startNodeIndex).to.be startNodeIndex

    description = 'sets the "startTextOffset" property to the third parameter' +
        ' value if it is a valid text offset for the selected element and node'
    it description, ->
      obj = new @klass('#content')
      startTextOffset = 4
      obj.setStart('p:nth-child(1)', 2, startTextOffset)
      expect(obj.startTextOffset).to.be startTextOffset

    describe 'raises an error when', ->

      beforeEach ->
        @selector = 'p:nth-child(1)'
        @nodeIndex = 2
        @textOffset = 0
        @expected = 'Expected error message not set. FIX!'

      afterEach ->
        obj = new @klass('#content')
        expect(=> obj.setStart(@selector, @nodeIndex, @textOffset)).to.
            throwError((e) =>
          expect(e.message).to.be @expected
        )

      it 'the selector parameter does not identify an existing selector', ->
        @selector = '#bogus'
        @expected = 'setStart was passed an invalid selector.'

      describe 'the node index parameter', ->

        it 'is not a valid node index for the selected element', ->
          @nodeIndex = 74
          @expected = 'setStart was passed an invalid node index.'

        it 'does not reference a text node within the selected element', ->
          @nodeIndex = 1
          @expected = 'setStart was passed a node index for a non-text node.'

      describe 'the text offset parameter', ->

        it 'is not a valid text offset for the selected node', ->
          @textOffset = 271
          @expected = 'setStart was passed an invalid text offset.'
