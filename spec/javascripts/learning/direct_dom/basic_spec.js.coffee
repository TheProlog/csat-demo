
#= require 'spec_helper'

getFixtureHtml = ->
    '<div id="content">' +
      '<p>' +
      'This is ordinary paragraph text within the body of the document,' +
      ' where certain words and phrases may be <em>emphasized</em> to mark' +
      ' them as <strong>particularly important</strong>.' +
      '</p>' +
      '<p>This is a test.</p>' +
      '<p id="p3">This is <em>another</em> test.</p>' +
    '</div>'

getSelectionContents = (startSelector, startNodeIndex, startTextOffset,
    endSelector, endNodeIndex, endTextOffset) ->
  r1 = document.createRange()
  r1.selectNode($(startSelector).get(0).childNodes[startNodeIndex])
  r1.setStart(r1.startContainer.childNodes[0], startTextOffset)
  r2 = document.createRange()
  r2.selectNode($(endSelector).get(0).childNodes[endNodeIndex])
  r1.setEnd(r2.startContainer.childNodes[endNodeIndex], endTextOffset)
  r1.cloneContents()

combineNodesAsString = (contents_in) ->
  contents = Object.clone(contents_in)
  contents.childNodes.to_a = ->
    ret = []
    # childNodes is a NodeList, *not* an Array. Pfffft.
    for index in [0...@length]
      ret.push @item(index)
    ret
  func = (p,c,i,a) =>
    newValue = if c.outerHTML then c.outerHTML else c.nodeValue
    p + newValue
  contents.childNodes.to_a().reduce(func, '')

################################################################################
################################################################################
################################################################################

describe 'Learning direct DOM selection', ->

  beforeEach ->
    fixture.set getFixtureHtml()

  describe 'by creating and selecting a range', ->

    it 'within a single element', ->
      selector = '#content p:nth-child(1) strong'
      contents = getSelectionContents(selector, 0, 13, selector, 0, 22)
      buffer = combineNodesAsString contents
      expect(buffer).to.be 'important'

    it 'that spans multiple nodes in the same element', ->
      selector = '#content p:nth-child(1)'
      contents = getSelectionContents(selector, 0, 0, selector, 2, 3)
      buffer = combineNodesAsString contents
      expected = getFixtureHtml().slice(21, 147)
      expect(buffer).to.be expected

    it 'that spans multiple elements', ->
      contents = getSelectionContents(
          '#content p:nth-child(1)', 0, 8,
          '#content p:nth-child(3)', 0, 4)
      buffer = combineNodesAsString contents
      expected = ['<p>', '</p>'].join getFixtureHtml().slice(29, 242)
      expect(buffer).to.be expected
