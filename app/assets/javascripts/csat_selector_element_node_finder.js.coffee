
#= require util/gateway

window.meldd_gateway.register 'CsatSelectorElementNodeFinder', class

  deriveId = (field) ->
    id = field.attr('id')
    part = id.match(/(.+?)_.*/)[1]
    ['#', '_selector'].join part

  getContentNodeFor = (id) ->
    CsatDemoContainers = window.meldd_gateway.use 'CsatDemoContainers'
    containers = new CsatDemoContainers()
    selector = containers.form().find(id).val()
    containers.container().find(selector).get(0)

  constructor: -> ;

  find: (field) ->
    selector_id = deriveId(field)
    debug.debug 'selector_id', selector_id
    getContentNodeFor selector_id
