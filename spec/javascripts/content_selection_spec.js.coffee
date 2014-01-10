
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

  describe 'has an API with', ->

    it 'a constructor which takes one parameter', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 1

    it 'a setStart method that takes three parameters', ->
      verifyMethodApi(new @klass('#content'), 'setStart', 3)

    it 'a setEnd method that takes three parameters', ->
      verifyMethodApi(new @klass('#content'), 'setEnd', 3)

    it 'a getContent method that takes no parameters', ->
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
          expect(e).to.be '#bogus is not a valid selector.'
        )

      it 'no parameter was specified', ->
        expect(=> new @klass()).to.throwError((e) ->
          expect(e).to.be 'ContentSelection constructor requires a parameter.'
        )
