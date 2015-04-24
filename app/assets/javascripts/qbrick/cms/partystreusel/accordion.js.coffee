#= require ./base
#= require ./scroll_to

class Accordion extends Partystreusel.Base
  @className = 'Accordion'

  constructor: (el) ->
    super
    title = @$el.find('.accordion__title')
    return if title.data('accordion-bound')

    title.on 'click', @toggleItem unless title.data('accordion-bound')
    title.data 'accordion-bound', 'true'

    @items = @$el.find('.accordion__item')
    @offset = @$el.data('scroll-offset')

  toggleItem: (e) =>
    item = $(e.target).closest('.accordion__item')
    currentOpen = item.hasClass('accordion__item--open')

    @items.filter('.accordion__item--open').each (_, i) =>
      @trigger('close', $(i))

    @items.removeClass('accordion__item--open')
    unless currentOpen
      item.toggleClass('accordion__item--open')
      @trigger('open', item)

    e.preventDefault()
    Partystreusel.scrollTo(item, @offset)

Partystreusel.Accordion = Accordion
