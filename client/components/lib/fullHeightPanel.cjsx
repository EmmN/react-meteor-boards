ReactBoards.FullHeightPanel = ReactMeteor.createClass
  componentDidMount: ->
    @recalculateSize()
    window.addEventListener 'resize', @recalculateSize

  componentWillUnmount: ->
    window.removeEventListener 'resize', @recalculateSize

  recalculateSize: ->
    @props.cssAttr ||= "height"
    @props.offset  ||= 0

    height = $(window).height() - @props.offset
    node   = React.findDOMNode(@)
    $(node).css @props.cssAttr, height

  render: ->
    <div className={@props.className}>{ @props.children }</div>
