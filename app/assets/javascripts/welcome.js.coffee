
#= require util/gateway

performValidation = (field, validatorClass) ->
  Validator = window.meldd_gateway.use validatorClass
  obj = new Validator({field})
  obj.validate()
  message = obj.message
  return undefined if message.length == 0
  return '* ' + message

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  performValidation field, 'NodeIndexValidator'

window.checkTextOffset = (field) ->
  performValidation field, 'TextOffsetValidator'

selectContent = ->
  throw 'Content selection not implemented: line 20 of welcome.js.coffee'

buttonHandler = (event) ->
  event.preventDefault()
  selectContent()

hijackSubmitButton = ->
  button = $('button.btn-primary')
  button.click(buttonHandler)

populateSelectorLists = ->
  # setupSelectControl '#start_selector'
  InitControl = window.meldd_gateway.use 'InitSelectorSelectControl'
  for selector in ['#start_selector', '#end_selector']
    new InitControl().setup({selector})

jQuery ->
  populateSelectorLists()
  hijackSubmitButton()
  $('#form1').validationEngine()
  $('#start_selector').focus()
