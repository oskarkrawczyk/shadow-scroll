# extend object with another objects
extend = (obj, extensions...) ->
  (obj[key] = value) for key, value of ext for ext in extensions
  obj

addEvent = (element, event, fn, useCapture = false) ->
  element.addEventListener event, fn, useCapture

setStyles = (element, styles) ->
  for key of styles
    element.style[key] = styles[key]

class SingleShadowScroll

  options:
    prefix: 'shadowScroll'
    noStyles: false

  constructor: (element, options) ->
    extend @options, options

    @cont = element

    @elements =
      top: document.createElement 'div'
      bottom: document.createElement 'div'

    @defaultStyles =
      top:
        width: '100%'
        height: '4px'
        position: 'absolute'
        top: 0
        left: 0
        background: 'linear-gradient(to bottom, rgba(0,0,0,0.05), rgba(0,0,0,0))'
        '-webkit-transition': 'opacity 0.2s'
      bottom:
        width: '100%'
        height: '4px'
        position: 'absolute'
        top: 0
        left: 0
        background: 'linear-gradient(to top, rgba(0,0,0,0.05), rgba(0,0,0,0))'
        '-webkit-transition': 'opacity 0.2s'

    @createElement @cont, 'top'
    @createElement @cont, 'bottom'

    addEvent @cont, 'scroll', @scroll

    @cont.style.position = 'relative' if @cont.style.position is ''
    @scroll()

  createElement: (context, element) ->
    @elements[element].setAttribute 'class', "#{@options.prefix}_#{element}"
    @elements[element] = context.appendChild @elements[element]
    setStyles @elements[element], @defaultStyles[element] unless @options.noStyles

  scroll: =>
    scrollTop = @cont.scrollTop
    clientHeight = @cont.clientHeight
    scrollHeight = @cont.scrollHeight
    shadowHeight = @elements.top.offsetHeight

    @elements.top.style.top = "#{scrollTop}px"
    @elements.bottom.style.top = "#{scrollTop + clientHeight - shadowHeight}px"

    @elements.top.style.opacity = scrollTop # if scrollTop <= 0 then 0 else 1
    @elements.bottom.style.opacity = if scrollTop + clientHeight >= scrollHeight then 0 else 1

class @ShadowScroll

  constructor: (selector, options) ->

    new SingleShadowScroll cont, options for cont in selector
