
#= require util/gateway

jQuery ->
  Setup = window.meldd_gateway.use 'CsatWelcomeScreenSetup'
  new Setup()
  $('#start_selector').focus()
