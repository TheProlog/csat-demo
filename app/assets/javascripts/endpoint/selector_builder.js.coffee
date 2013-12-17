
#= require util/gateway

window.meldd_gateway.register 'SelectorBuilder', class

  withnthChild = (element) ->
    getFirstNode = (obj) ->
      return obj.get(0) if obj.jquery?
      obj

    ret = ''
    node = getFirstNode(element)
    if node?.tagName
      ret = node.tagName.toLowerCase()
      nthChild = element.prevAll().length + 1
      ret += [':nth-child(', ')'].join(nthChild)
    ret

  constructor: (@baseSelector = '#content') -> ;

  selectorFor: (element) ->
    parts = [withnthChild element]
    for parent in element.parentsUntil(@baseSelector)
      parts.append [withnthChild $(parent)]
    parts.reverse().join ' > '
