
#= require util/gateway

window.meldd_gateway.register 'CSSpec describeAnEnd', (whichEnd) ->
  headEnd = whichEnd.toLowerCase()
  tailEnd = headEnd.capitalize()

  describe "has a set#{tailEnd} method that", ->

    description = 'sets the "' + "#{headEnd}Selector" + '" property to the' +
        'first parameter value if it is a valid selector'
    it description, ->
      obj = new @klass('#content')
      selector = 'p:nth-child(1)'
      obj["set#{tailEnd}"](selector, 0, 0)
      # WTF: Normal expect doesn't work for strings; does work for integers.
      actual = obj["#{headEnd}Selector"]
      expect(actual == selector).to.be true

    description = 'sets the "' + "#{headEnd}NodeIndex" + '" property to the' +
        'second parameter value if it is a valid node index for ' +
        "@#{headEnd}Element"
    it description, ->
      obj = new @klass('#content')
      nodeIndex = 2
      obj["set#{tailEnd}"]('p:nth-child(1)', nodeIndex, 0)
      actual = obj["#{headEnd}NodeIndex"]
      expect(actual).to.be nodeIndex

    description = 'sets the "' + "#{headEnd}TextOffset" + '" property to the' +
        'third parameter value if it is a valid text offset for the selected' +
        'element and node'
    it description, ->
      obj = new @klass('#content')
      textOffset = 4
      obj["set#{tailEnd}"]('p:nth-child(1)', 2, textOffset)
      actual = obj["#{headEnd}TextOffset"]
      expect(actual).to.be textOffset

    describe 'raises an error when', ->

      beforeEach ->
        @selector = 'p:nth-child(1)'
        @nodeIndex = 2
        @textOffset = 0
        @expected = "set#{tailEnd} "

      afterEach ->
        obj = new @klass('#content')
        setter = obj["set#{tailEnd}"]
        expect(=> setter.call @, @selector, @nodeIndex, @textOffset).to.
            throwError((e) =>
          expect(e.message).to.be @expected
        )

      it 'the selector parameter does not identify an existing selector', ->
        @selector = '#bogus'
        @expected += 'was passed an invalid selector.'

      describe 'the node index parameter', ->

        it 'is not a valid node index for the selected element', ->
          @nodeIndex = 74
          @expected += 'was passed an invalid node index.'

        it 'does not reference a text node within the selected element', ->
          @nodeIndex = 1
          @expected += 'was passed a node index for a non-text node.'

      describe 'the text offset parameter', ->

        it 'is not a valid text offset for the selected node', ->
          @textOffset = 271
          @expected += 'was passed an invalid text offset.'
