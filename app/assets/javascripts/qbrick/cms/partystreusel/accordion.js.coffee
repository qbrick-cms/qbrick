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
    action = if currentOpen then 'close' else 'open'

    item.toggleClass('accordion__item--open')
    @trigger(action, item)
    e.preventDefault()
    Partystreusel.scrollTo(item, @offset)

  @closeAll =  (e) =>
    $('.accordion__item--open', '.brick-list').each (_, i) =>
      $(i).removeClass('accordion__item--open')
      $(i).trigger.call($(i), 'accordion-close')

  @expandAll =  (e) ->
    $('.accordion__item', '.brick-list').each (_, i) =>
      $(i).addClass('accordion__item--open')
      $(i).trigger.call($(i), 'accordion-open')


Partystreusel.Accordion = Accordion
