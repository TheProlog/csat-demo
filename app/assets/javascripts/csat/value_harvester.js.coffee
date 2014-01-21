
#= require util/gateway

window.meldd_gateway.register 'CsatValueHarvester', class

  defaultFindSelectedElementFor = (baseSelector, selector) ->
    # Finding using the value of the field as a selector — NOT simply finding and
    # returning the value of the field!
    $(baseSelector).find($(selector).val())

  defaultGetIntegerValueForField = (whichEnd, field) ->
    selector = 'input#{1}_{2}'.assign(whichEnd, field)
    $(selector).val().toNumber()

  getSelectorValue = (whichEnd) ->
    itemSelector = ['select#', '_selector'].join whichEnd
    @findSelectedElementFor @baseSelector, itemSelector

  getNodeIndex = (whichEnd) ->
    @getIntegerValueForField(whichEnd, 'nodeindex')

  getTextOffset = (whichEnd) ->
    @getIntegerValueForField(whichEnd, 'textoffset')

  valuesFor = (whichEnd) ->
    selector = getSelectorValue.call @, whichEnd
    nodeIndex = getNodeIndex.call @, whichEnd
    offset = getTextOffset.call @, whichEnd
    baseSelector = @baseSelector
    {selector, nodeIndex, offset, baseSelector}

  constructor: (params = {}) ->
    @baseSelector = params.baseSelector || '.boilerplate'
    @findSelectedElementFor = params.findSelectedElementFor ||
        defaultFindSelectedElementFor
    @getIntegerValueForField = params.getIntegerValueForField ||
      defaultGetIntegerValueForField

  values: ->
    startValues = valuesFor.call @, 'start'
    endValues = valuesFor.call @, 'end'
    {
      start:        startValues
      end:          endValues
    }
