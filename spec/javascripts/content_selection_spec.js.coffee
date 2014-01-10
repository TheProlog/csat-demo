
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

describe 'ContentSelection class', ->

  beforeEach ->
    setupFixture()
    @klass = window.meldd_gateway.use 'ContentSelection'

  describe 'has an API with', ->

    it 'a constructor which takes one parameter', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 1

    it 'a setStart method that takes three parameters', ->
      obj = new @klass('#content')
      expect(obj.setStart).to.be.a 'function'
      expect(obj.setStart).to.have.length 3

    it 'a setEnd method that takes three parameters', ->
      obj = new @klass('#content')
      expect(obj.setEnd).to.be.a 'function'
      expect(obj.setEnd).to.have.length 3

    it 'a getContent method that takes no parameters', ->
      obj = new @klass('#content')
      expect(obj.getContent).to.be.a 'function'
      expect(obj.getContent).to.have.length 0
