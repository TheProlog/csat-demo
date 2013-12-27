
#= require util/gateway

window.meldd_gateway.register 'CsatNodeIndexFinder', class

  deriveId = (field) ->
    id = field.attr('id')
    part = id.match(/(.+?)_.*/)[1]
    ['#', '_nodeindex'].join part

  getValueBasedOn = (id) ->
    CsatDemoContainers = window.meldd_gateway.use 'CsatDemoContainers'
    containers = new CsatDemoContainers()
    containers.form().find(id).val().toInt()

  constructor: -> ;

  find: (field) ->
    selectorId = deriveId(field)
    getValueBasedOn selectorId
