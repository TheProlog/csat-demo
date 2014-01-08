
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

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  debug.debug 'window.checkNodeIndex', field
  performValidation field, 'NodeIndexValidator'

window.checkTextOffset = (field) ->
  performValidation field, 'TextOffsetValidator'

showSelectionAlert = ->
  SelectionAlert = window.meldd_gateway.use 'SelectionAlert'
  new SelectionAlert().show()

getEndpointValues = ->
  CsatValueHarvester = window.meldd_gateway.use 'CsatValueHarvester'
  new CsatValueHarvester().values()

setRangeEndpoint = (endpoint, setter) ->
  el = $(endpoint.selector)
  setter({container: el[endpoint.nodeIndex], offset: endpoint.offset})

createSelection = ->
  endpoints = getEndpointValues()
  r = new $.Range(endpoints.start.selector)
  setRangeEndpoint endpoints.start, r.start
  setRangeEndpoint endpoints.end, r.end
  debug.debug $.Range.current()
  # new $.Range($.Range.current())

selectContent = ->
  showSelectionAlert()
  createSelection()

formIsValid = ->
  getForm().validationEngine('validate')

buttonHandler = (event) ->
  event.preventDefault()
  selectContent() if formIsValid()

setupForm = (params) ->
  CsatFormInitialiser = window.meldd_gateway.use 'CsatFormInitialiser'
  new CsatFormInitialiser().setup(params)

jQuery ->
  setupForm {handler: buttonHandler, selectButton: $('button.btn-primary')}
  getForm().validationEngine()
  $('#start_selector').focus()
