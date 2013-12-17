
#= require util/gateway

window.meldd_gateway.register 'TextNodeFinder', class

  # still somewhat naive, but works for now; breaks on <br/>, <hr/>
  getFirstNonElementChild = (node) ->
    keepGoing = (node) ->
      node?.nodeType == Node.ELEMENT_NODE
    while keepGoing(node)
      node = node.childNodes[0]
    node

  getElementNode = (node) ->
    node.childNodes[0] if node?.nodeType == Node.ELEMENT_NODE

  getjQueryNode = (node) ->
    node.get(0).childNodes[0] if node?.jquery

  getTextNode = (node) -> node if node?.nodeType == Node.TEXT_NODE

  constructor: (@baseSelector) -> ;

  firstTextNode: (base) ->
    if base
      node = getTextNode(base) or getElementNode(base) or getjQueryNode(base)
    else
      node = $(@baseSelector).get(0)
    getFirstNonElementChild(node)
