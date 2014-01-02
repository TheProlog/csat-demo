
#= require util/gateway

formatValidationMessage = (message) ->
  if message.length == 0
    undefined
  else
    '* ' + message

getForm = -> $('#form1');

getValidatorInstance = (validatorClass, params) ->
  Validator = window.meldd_gateway.use validatorClass
  new Validator(params)

performValidation = (field, validatorClass) ->
  obj = getValidatorInstance(validatorClass, {field})
  obj.validate()
  formatValidationMessage obj.message

setupInitControl = (selector) ->
  InitControl = window.meldd_gateway.use 'InitSelectorSelectControl'
  new InitControl().setup({selector})

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  debug.debug 'window.checkNodeIndex', field
  performValidation field, 'NodeIndexValidator'

window.checkTextOffset = (field) ->
  performValidation field, 'TextOffsetValidator'

selectContent = ->
  SelectionAlert = window.meldd_gateway.use 'SelectionAlert'
  new SelectionAlert().show()

formIsValid = ->
  getForm().validationEngine('validate')

buttonHandler = (event) ->
  event.preventDefault()
  selectContent() if formIsValid()

hijackSubmitButton = ->
  button = $('button.btn-primary')
  button.click(buttonHandler)

populateSelectorLists = ->
  setupInitControl '#start_selector'
  setupInitControl '#end_selector'

jQuery ->
  populateSelectorLists()
  hijackSubmitButton()
  getForm().validationEngine()
  $('#start_selector').focus()
