
#= require util/gateway

window.meldd_gateway.register 'CsatNodeIndexFinder', class

  demoContainersInstance = ->
    CsatDemoContainers = window.meldd_gateway.use 'CsatDemoContainers'
    new CsatDemoContainers()

  deriveId = (field) ->
    id = field.attr('id')
    part = id.match(/(.+?)_.*/)[1]
    ['#', '_nodeindex'].join part

  getValueBasedOn = (id) ->
    field = demoContainersInstance().form().find(id)
    field.val().toInt()

  constructor: -> ;

  find: (field) ->
    selectorId = deriveId(field)
    getValueBasedOn selectorId
