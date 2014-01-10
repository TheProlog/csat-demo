
#= require util/gateway
#
window.meldd_gateway.register 'InitSelectorSelectControl', class

  getConfig = () ->
    {
      option_tag:             '<option>'
      option_selected_tail:   ' option:selected'
      classes:  {
        selector_collection:  'SelectorCollection'
      }
      defaults: {
        content_base:         '.boilerplate'
        delay:                80
        flashes:              3
      }
    }

  buildOptionFor = (selector) ->
    $(getConfig().option_tag).text(selector)

  changeHandler = (event) =>
    unpackEventData = (event_data) ->
      [event_data.selector,
        event_data.delay,
        event_data.flashes,
        event_data.content_base]

    [form_selector, delay, flashes, content_base] = unpackEventData event.data
    form_selector += getConfig().option_selected_tail
    selector = $(form_selector).text()
    for index in [0..flashes]
      $(content_base).find(selector).fadeOut(delay).fadeIn(delay)

  getSelectorCollection = ->
    className = getConfig().classes.selector_collection
    SelectorCollection = window.meldd_gateway.use className
    new SelectorCollection(@content_base).collection()

  parse_params = (params) ->
    @delay = params.delay || getConfig().defaults.delay
    @flashes = params.flashes || getConfig().defaults.flashes
    @content_base = params.content_base || getConfig().defaults.content_base
    @selector = params.selector

  addSelectorsToControl = (list_selector, selectors) ->
    list = $(list_selector)
    for selector in selectors
      list.append buildOptionFor(selector)
    list

  #############################################################################
  #                            PUBLIC API FOLLOWS                             #
  #############################################################################

  constructor: -> ;

  setup: (params = {}) ->
    parse_params.call @, params
    selectors = getSelectorCollection.call @
    addSelectorsToControl(@selector, selectors).change @, changeHandler
    null
