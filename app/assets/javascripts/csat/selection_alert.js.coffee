
#= require util/gateway

CancelButton = class

  getWrappedClass = ->
    window.meldd_gateway.use 'UtilButton'

  constructor: ->
    @button = new getWrappedClass()
    @button.attrs['aria-hidden'] = true
    @button.attrs['data-dismiss'] = 'alert'

  html: ->
    @button.html '&times'

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

  updateDisplayedMarkup = (html) ->
    $('#alertbox').html(html).addClass('alert alert-info fade in').alert()

  constructor: -> ;

  show: (alertSelector = '#alertbox') ->
    report = createSelectionReport()
    html = new CancelButton().html() + report.outerHTML()
    updateDisplayedMarkup(html)