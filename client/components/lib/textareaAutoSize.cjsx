ReactBoards.TextareaAutosize = React.createClass
  render: ->
    Input = ReactBootstrap.Input

    props = _.extend {}, @props,
      onChange : @onChange
      style    : _.extend {}, @props.style, overflow: 'hidden'

    <Input type="textarea" {...props} />

  getValue: ->
    @getEl().value

  getEl: ->
    React.findDOMNode(@).getElementsByTagName("TEXTAREA")[0]

  componentDidMount: ->
    @recalculateSize()
    window.addEventListener 'resize', @recalculateSize

  componentWillUnmount: ->
    window.removeEventListener 'resize', @recalculateSize

  componentDidUpdate: (prevProps) ->
    if prevProps.style or prevProps.value != @props.value or @props.value == null
      @recalculateSize()

  onChange: (e) ->
    if @props.onChange
      @props.onChange e
    if @props.value == undefined
      @recalculateSize()

  recalculateSize: ->
    diff = undefined
    node = undefined
    node = @getEl()
    if window.getComputedStyle
      styles = window.getComputedStyle(node)
      # If the textarea is set to border-box, it's not necessary to
      # subtract the padding.
      if styles.getPropertyValue('box-sizing') == 'border-box' or styles.getPropertyValue('-moz-box-sizing') == 'border-box' or styles.getPropertyValue('-webkit-box-sizing') == 'border-box'
        diff = 0
      else
        diff = parseInt(styles.getPropertyValue('padding-bottom') or 0, 10) + parseInt(styles.getPropertyValue('padding-top') or 0, 10)
    else
      diff = 0

    node = @getEl()
    node.style.height = 'auto'
    node.style.height = node.scrollHeight - diff + 'px'
