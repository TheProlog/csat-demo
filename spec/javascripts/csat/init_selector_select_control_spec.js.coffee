
#= require util/gateway

doEventHandlerSpecSetup = (obj, eventHandler) ->
  getSelectorCollection = ->
    ['p:nth-child(1)', 'h5:nth-child(2)', 'p:nth-child[3]']
  params = {
    eventHandler
    getSelectorCollection
    selector: '#start_selector'
  }
  debug.debug 'Line 12', obj
  obj.setup params

setSelectorFixtureHtml = ->
  html = '<form><select id="start_selector"></select></form>'
  fixture.set html

specifyCardinalConfigSetting = (name, defaultValue, unitName) ->

  describe 'the "{1}" property, such that'.assign(name), ->

    beforeEach ->
      @defaultValue = defaultValue

    description = 'by default it has a value of {1} ({2})'.
        assign(defaultValue, unitName)
    it description, ->
      eventHandler = (e) ->
        ;
      doEventHandlerSpecSetup.call @, @obj, eventHandler
      expect(@obj[name]).to.be @defaultValue

    it 'it accepts a positive numeric value as an override', ->
      value = 30
      params = {}; params[name] = value
      @obj.setup params
      expect(@obj[name]).to.be value

    describe 'ignores override and uses the default when given a', ->

      afterEach ->
        params = {}; params[name] = @value
        @obj.setup params
        expect(@obj[name]).to.be @defaultValue

      it 'non-numeric value', ->
        @value = 'bogus'

      it 'non-integer value', ->
        @value = 42.7

      it 'negative value', ->
        @value = -4

################################################################################
####                             SPECS START HERE                           ####
################################################################################

describe 'InitSelectorSelectControl class', ->

  beforeEach ->
    @klass = window.meldd_gateway.use 'InitSelectorSelectControl'
    html = '<div id="content"><p>This is a test.</p></div>'
    fixture.set html

  describe 'has an API that includes', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass.length).to.be 0

    it 'a "setup" method that takes one parameter', ->
      obj = new @klass()
      expect(obj.setup).to.be.a 'function'
      expect(obj.setup.length).to.be 1

  describe 'has a setup method that', ->

    beforeEach ->
      @obj = new @klass()

    describe 'accepts configuration settings for', ->

      specifyCardinalConfigSetting.call @, 'delay', 80, 'milliseconds'

      specifyCardinalConfigSetting.call @, 'flashes', 3, 'flashes'

      describe 'the "context_base" property, such that', ->

        it 'by default is has a value of ".boilerplate"', ->
          @obj.setup()
          expect(@obj.content_base).to.be '.boilerplate'

        it 'accepts a non-empty string as a parameter', ->
          @obj.setup({content_base: 'whatever'})
          expect(@obj.content_base).to.be 'whatever'

        describe 'ignores override and uses the default when given a', ->

          it 'blank or empty string', ->
            @obj.setup({content_base: ' '})
            expect(@obj.content_base).to.be '.boilerplate'

      describe 'the "selector" property, such that', ->

        it 'has no default value', ->
          @obj.setup()
          expect(@obj.selector).to.be undefined

        it 'accepts a non-empty string as a parameter', ->
          @obj.setup({selector: 'whatever'})
          expect(@obj.selector).to.be 'whatever'

      describe 'the "getSelectorCollection" property, such that it', ->

        it 'can be overridden to provide "canned" selectors', ->
          getSelectorCollection = ->
            ['p:nth-child(1)', 'h5:nth-child(2)', 'p:nth-child[3]']
          @obj.setup({getSelectorCollection, selector: 'p:nth-child(3)'})
          expect(@obj.getSelectorCollection).to.be getSelectorCollection

      describe 'the "eventHandler" property, such that it', ->

        it 'can be overridden to, e.g., verify proper event handling', ->
          setSelectorFixtureHtml()
          capturedData = undefined
          eventHandler = (event) -> capturedData = event.data;
          doEventHandlerSpecSetup @obj, eventHandler
          $('#start_selector').trigger 'change', @obj
          expect(capturedData).to.be @obj

    it 'returns a null value', ->
      obj = new @klass()
      selector = 'p:nth-child(1)'
      expect(obj.setup({selector})).to.be null

