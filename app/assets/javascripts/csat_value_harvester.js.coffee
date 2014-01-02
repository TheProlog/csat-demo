
#= require util/gateway

window.meldd_gateway.register 'CsatValueHarvester', class

  getSelectorValue = (whichEnd) ->
    itemSelector = ['select#', '_selector'].join whichEnd
    # Finding using the value of the field as a selector — NOT simply finding and
    # returning the value of the field!
    $(@baseSelector).find($(itemSelector).val())

  getNodeIndex = (whichEnd) ->
    itemSelector = ['input#', '_nodeindex'].join whichEnd
    $(itemSelector).val().toInt()

  getTextOffset = (whichEnd) ->
    itemSelector = ['input#', '_textoffset'].join whichEnd
    $(itemSelector).val().toInt()

  valuesFor = (whichEnd) ->
    selector = getSelectorValue.call @, whichEnd
    nodeIndex = getNodeIndex.call @, whichEnd
    offset = getTextOffset.call @, whichEnd
    baseSelector = @baseSelector
    {selector, nodeIndex, offset, baseSelector}

  constructor: (@baseSelector = '.boilerplate') -> ;

  values: ->
    startValues = valuesFor.call @, 'start'
    endValues = valuesFor.call @, 'end'
    {
      start:        startValues
      end:          endValues
    }

