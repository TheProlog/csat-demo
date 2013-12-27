
#= require spec_helper

describe 'TextOffsetLimitFinder class', ->

  beforeEach ->
    html = '<form></form><div class="boilerplate">' +
        '<p>This <em>is</em> a test.</p>' +
        '</div>'
    fixture.set html
    @klass = window.meldd_gateway.use 'TextOffsetLimitFinder'

  describe 'has a public API that includes', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'a getLimit method that takes one parameter', ->
      obj = new @klass()
      expect(obj.getLimit).to.be.a 'function'
      expect(obj.getLimit).to.have.length 1

  it 'needs more specs'
