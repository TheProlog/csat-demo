
#= require util/gateway

window.meldd_gateway.register 'SelectionAlert', class

  createCancelButton = ->
    button = $('<button>').
        attr(type: 'button').
        attr('aria-hidden': true).
        attr('data-dismiss': 'alert').
        addClass('button').
        html('&times')

  createEndpointFrom = (values) ->
    node = $(values.selector).get(0).childNodes[values.nodeIndex]
    debug.debug 'CsatValueHarvester.getNodeIndex', $('#start_nodeindex').val(), values, node
    Endpoint = window.meldd_gateway.use 'Endpoint'
    new Endpoint(node, values.offset, values.baseSelector)

  getFieldValues = ->
    CsatValueHarvester = window.meldd_gateway.use 'CsatValueHarvester'
    new CsatValueHarvester().values()

  buildItemSpan = (content) ->
    $('<span>').html(content).outerHTML()

  buildSelectionEndpointMarkup = (endpoint, name) ->
    'The ' + name + 'ing endpoint has the selector ' +
        buildItemSpan(endpoint.selector()) +
        ', the node index ' + buildItemSpan(endpoint.nodeIndex()) +
        ', and the text offset ' + buildItemSpan(endpoint.textOffset()) + '.'

  buildSelectionMarkup = (start, end) ->
    markup = 'Selection has the base selector ' + start.baseSelector + '. ' +
        buildSelectionEndpointMarkup(start, 'start') +
        buildSelectionEndpointMarkup(end, 'end')
    $('<div>').attr('id', 'selection-values').html(markup)

  createSelectionReport = ->
    endpointValues = getFieldValues()
    start = createEndpointFrom endpointValues.start
    end = createEndpointFrom endpointValues.end
    buildSelectionMarkup start, end

  constructor: -> ;

  show: (alertSelector = '#alertbox') ->
    button = createCancelButton()
    report = createSelectionReport()
    html = button.outerHTML() + report.outerHTML()
    $('#alertbox').html(html).addClass('alert alert-info fade in').alert()
