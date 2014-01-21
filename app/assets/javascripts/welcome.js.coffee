
#= require util/gateway

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  Wrapper = window.meldd_gateway.use 'CsatFieldValidationWrapper'
  new Wrapper().setup field, 'CsatNodeIndexChecker'

window.checkTextOffset = (field) ->
  Wrapper = window.meldd_gateway.use 'CsatFieldValidationWrapper'
  new Wrapper().setup field, 'CsatTextOffsetChecker'

class CsatWelcomeScreenSetup

  setupForm = (params) ->
    CsatFormInitialiser = window.meldd_gateway.use 'CsatFormInitialiser'
    new CsatFormInitialiser().setup(params)

  callEndpointSetter = (endpoint, setter) ->
    selector = endpoint.selector.selector
    nodeIndex = endpoint.nodeIndex
    offset = endpoint.offset
    setter.call @, selector, nodeIndex, offset

  getEndpointValues = ->
    CsatValueHarvester = window.meldd_gateway.use 'CsatValueHarvester'
    new CsatValueHarvester().values()

  getSelectionInstance = (baseSelector) ->
    ContentSelection = window.meldd_gateway.use 'ContentSelection'
    new ContentSelection(baseSelector)

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
    $('#form').validationEngine('validate')

  defaultButtonHandler = (event) ->
    event.preventDefault()
    selectContent() if formIsValid()

  constructor: (params_in = {}) ->
    handler = params_in.buttonHandler || defaultButtonHandler
    buttonSelector = params_in.buttonSelector || 'button.btn-primary'
    setupForm.call @, {handler, selectButton: $(buttonSelector)}
    $('form').validationEngine()

jQuery ->
  new CsatWelcomeScreenSetup()
  $('#start_selector').focus()
