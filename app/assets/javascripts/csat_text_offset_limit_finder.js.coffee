
#= require util/gateway

window.meldd_gateway.register 'TextOffsetLimitFinder', class

  findLimitBasedOn = (field) ->
    ElementNodeFinder = window.meldd_gateway.use 'CsatSelectorElementNodeFinder'
    element = new ElementNodeFinder().find(field)
    NodeIndexFinder = window.meldd_gateway.use 'CsatNodeIndexFinder'
    nodeIndex = new NodeIndexFinder().find(field)
    node = element.childNodes[nodeIndex]
    node.length - 1

  constructor: -> ;

  getLimit: (associated_field) ->
    findLimitBasedOn associated_field
