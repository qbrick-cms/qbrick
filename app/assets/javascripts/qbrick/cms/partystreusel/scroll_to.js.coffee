#= require ./namespace
Partystreusel.scrollTo = (x, relativeOffset = 0) ->
  if typeof x == 'object' && !(x instanceof $)
    # expect this is a hash and link is defined
    x = $("a[name=#{JSON.stringify(x.link)}]")

  if typeof x == 'string'
    x = $(x)
  if typeof x != 'number'
    x = x.offset()?.top

  return false unless x?

  x = Math.round(x) + relativeOffset
  $("html,body").animate({scrollTop: x}, 'slow')
