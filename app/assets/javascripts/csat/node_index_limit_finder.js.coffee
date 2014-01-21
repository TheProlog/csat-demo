
#= require util/gateway

window.meldd_gateway.register 'NodeIndexLimitFinder', class

  findLimitBasedOn = (field) ->
    ElementNodeFinder = window.meldd_gateway.use 'CsatSelectorElementNodeFinder'
    node = new ElementNodeFinder().find(field)
    node.childNodes.length - 1

  constructor: -> ;

  getLimit: (associated_field) ->
    findLimitBasedOn(associated_field)
