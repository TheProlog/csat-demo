
#= require spec_helper

describe 'CsatDemoContainers class', ->

  beforeEach ->
    fixture.set '<form></form><div class="boilerplate"><p></p></div>'
    @klass = window.meldd_gateway.use 'CsatDemoContainers'

  describe 'has a public API that includes', ->

    it 'a constructor that takes no parameters', ->
      expect(@klass).to.be.a 'function'
      expect(@klass).to.have.length 0

    it 'a "container" method that takes no parameters', ->
      obj = new @klass()
      expect(obj.container).to.be.a 'function'
      expect(obj.container).to.have.length 0

    it 'a "form" method that takes no parameters', ->
      obj = new @klass()
      expect(obj.form).to.be.a 'function'
      expect(obj.form).to.have.length 0

  describe 'the "container" method', ->

    beforeEach ->
      obj = new @klass()
      @container = obj.container()

    it 'returns a jQuery object with the class name "boilerplate"', ->
      expect(@container.jquery).to.be.a 'string'
      expect(@container.attr('class')).to.be 'boilerplate'

  describe 'the "form" method', ->

    beforeEach ->
      obj = new @klass()
      @form = obj.form()

    it 'returns a jQuery object with the tag name "form"', ->
      expect(@form.jquery).to.be.a 'string'
      tagName = @form.get(0).tagName.toLowerCase()
      expect(tagName).to.be 'form'
