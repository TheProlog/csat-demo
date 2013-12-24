
#= require util/gateway

populateSelectorLists = ->
  # setupSelectControl '#start_selector'
  InitControl = window.meldd_gateway.use 'InitSelectorSelectControl'
  new InitControl().setup({selector: '#start_selector'})
  new InitControl().setup({selector: '#end_selector'})

jQuery ->
  populateSelectorLists()
  $('#form1').validationEngine()
  $('#start_selector').focus()

