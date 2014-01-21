
#= require util/gateway

# Amazed this isn't part of a standard library somewhere accessible.
window.meldd_gateway.register 'CsatIsscParamParser', class

  parseCardinal = (param, defaultValue) ->
    ret = Number(param)
    return defaultValue if Object.isNaN(ret) or !ret.isInteger() or ret < 0
    ret

  parseSelector = (param, defaultValue) ->
    if !param? || String(param).isBlank() then defaultValue else param

  constructor: -> ;

  parse: (params, defaults) ->
    for item in ['delay', 'flashes']
      @[item] = parseCardinal params[item], defaults[item]
    for item in ['content_base', 'selector']
      @[item] = parseSelector params[item], defaults[item]

window.meldd_gateway.register 'InitSelectorSelectControl', class

  getConfig = () ->
    {
      option_tag:             '<option>'
      option_selected_tail:   ' option:selected'
      defaults: {
        content_base:         '.boilerplate'
        delay:                80
        flashes:              3
      }
    }

  buildOptionFor = (selector) ->
    $(getConfig().option_tag).text(selector)

  defaultEventHandler = (event) =>
    unpackEventData = (event_data) ->
      [event_data.selector,
        event_data.delay,
        event_data.flashes,
        event_data.content_base]

    [form_selector, delay, flashes, content_base] = unpackEventData event.data
    form_selector += getConfig().option_selected_tail
    selector = $(form_selector).text()
    flashes.times (index) ->
      $(content_base).find(selector).fadeOut(delay).fadeIn(delay)

  defaultAddSelectorsToControl = (list_selector, selectors) ->
    list = $(list_selector)
    for selector in selectors
      list.append buildOptionFor(selector)
    list

  defaultGetSelectorCollection = ->
    SelectorCollection = window.meldd_gateway.use 'SelectorCollection'
    new SelectorCollection(@content_base).collection()

  defaultParamParser = (parser, params, defaults) ->
    parser.parse(params, defaults)
    for item in ['delay', 'flashes', 'content_base', 'selector']
      @[item] = parser[item]

  parseParams = (params) ->
    ParamParser = window.meldd_gateway.use 'CsatIsscParamParser'
    parser = new ParamParser()
    paramParser = params.paramParser || defaultParamParser
    paramParser.call @, parser, params, getConfig().defaults
    @eventHandler = params.eventHandler || defaultEventHandler
    @addSelectorsToControl =
        params.addSelectorsToControl || defaultAddSelectorsToControl
    @getSelectorCollection =
        params.getSelectorCollection || defaultGetSelectorCollection

  #############################################################################
  #                            PUBLIC API FOLLOWS                             #
  #############################################################################

  constructor: -> ;

  setup: (params = {}) ->
    parseParams.call @, params
    selectors = @getSelectorCollection.call @
    @addSelectorsToControl.call(@, @selector, selectors).change @, @eventHandler
    null
