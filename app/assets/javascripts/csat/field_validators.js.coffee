
#= require util/gateway

# actual call has parameter list: (field, rules, i, options) [if we care later]
window.checkNodeIndex = (field) ->
  Wrapper = window.meldd_gateway.use 'CsatFieldValidationWrapper'
  new Wrapper().setup field, 'CsatNodeIndexChecker'

window.checkTextOffset = (field) ->
  Wrapper = window.meldd_gateway.use 'CsatFieldValidationWrapper'
  new Wrapper().setup field, 'CsatTextOffsetChecker'
