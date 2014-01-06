
#= require util/gateway

window.meldd_gateway.register 'CsatFormInitialiser', class

  setupInitControl = (which) ->
    selector = ['#', '_selector'].join which
    InitControl = window.meldd_gateway.use 'InitSelectorSelectControl'
    new InitControl().setup({selector})

  populateSelectorLists = ->
    setupInitControl which for which in ['start', 'end']

  findSubmitButton = (params) ->
    return params.selectButton if params.selectButton
    return $(params.buttonSelector) if params.buttonSelector
    $('button.btn-primary')

  hijackSubmitButton = (params) ->
    findSubmitButton(params).click(params.handler)

  constructor: -> ;

  setup: (params) ->
    populateSelectorLists()
    hijackSubmitButton(params)
