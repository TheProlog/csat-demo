
window.meldd ||= {}

window.meldd.Gateway = class
  constructor: ->
    @items = {}
    @groups = {}

  register: (name, value, groups...) ->
    name ||= null
    old = @items[name]
    @items[name] = value
    for group in groups
      @groups[group] ||= []
      @groups[group].push name
    old

  use: (name) ->
    return @items[name] if @items[name]?
    undefined

  useGroup: (param) ->
    return [] unless @groups[param]?
    ret = []
    ret.push @items[itemKey] for itemKey in @groups[param]
    ret

window.meldd_gateway ||= new window.meldd.Gateway()
