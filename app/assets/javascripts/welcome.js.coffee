
#= require util/gateway

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  NodeIndexValidator = window.meldd_gateway.use 'NodeIndexValidator'
  obj = new NodeIndexValidator({field})
  obj.validate()
  message = obj.message
  return undefined if message.length == 0
  return '* ' + message

populateSelectorLists = ->
  # setupSelectControl '#start_selector'
  InitControl = window.meldd_gateway.use 'InitSelectorSelectControl'
  for selector in ['#start_selector', '#end_selector']
    new InitControl().setup({selector})

jQuery ->
  populateSelectorLists()
  $('#form1').validationEngine()
  $('#start_selector').focus()

