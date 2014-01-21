
#= require util/gateway

callEndpointSetter = (endpoint, setter) ->
  selector = endpoint.selector.selector
  nodeIndex = endpoint.nodeIndex
  offset = endpoint.offset
  setter.call @, selector, nodeIndex, offset

formatValidationMessage = (message) ->
  if message.length == 0
    undefined
  else
    '* ' + message

getForm = -> $('#form1');

getSelectionInstance = (baseSelector) ->
  ContentSelection = window.meldd_gateway.use 'ContentSelection'
  new ContentSelection(baseSelector)

getValidatorInstance = (validatorClass, params) ->
  Validator = window.meldd_gateway.use validatorClass
  new Validator(params)

performValidation = (field, validatorClass) ->
  obj = getValidatorInstance(validatorClass, {field})
  obj.validate()
  formatValidationMessage obj.message

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  performValidation field, 'CsatNodeIndexChecker'

window.checkTextOffset = (field) ->
  performValidation field, 'CsatTextOffsetChecker'

getEndpointValues = ->
  CsatValueHarvester = window.meldd_gateway.use 'CsatValueHarvester'
  new CsatValueHarvester().values()

getSelectedContent = ->
  endpoints = getEndpointValues()
  selectionObj = getSelectionInstance endpoints.start.baseSelector
  callEndpointSetter.call selectionObj, endpoints.start, selectionObj.setStart
  callEndpointSetter.call selectionObj, endpoints.end, selectionObj.setEnd
  selectionObj.getContent()

selectContent = ->
  content = getSelectedContent()
  $('#alertbox').html(content.escapeHTML()).
      addClass('alert alert-info fade in').alert()

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
