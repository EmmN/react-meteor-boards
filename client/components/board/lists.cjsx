ReactBoards.List = ReactMeteor.createClass
  render: ->
    return <div /> unless @state.list

    @listContentClass = "list-content"

    Link = ReactRouter.Link

    CardOnBoard     = ReactBoards.CardOnBoard
    CardAdd         = ReactBoards.CardAdd
    FullHeightPanel = ReactBoards.FullHeightPanel

    offset = ReactBoards.constants.navbarHeight
    offset += ReactBoards.constants.titleHeight
    offset += ReactBoards.constants.footerHeight
    offset += ReactBoards.constants.scrollbarHeight
    offset += ReactBoards.constants.listHeaderHeight

    <div>
      <h5>
        {@state.list.name}
        <span className="actions-dropdown dropdown pull-right">
          <button className="btn btn-link dropdown-toggle" type="button" id="actionsMenu" data-toggle="dropdown" aria-expanded="true">
            <span className="fa fa-gears"></span>
          </button>
          <ul className="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="actionsMenu">
            <li role="presentation">
              <a role="menuitem" tabIndex="-1" href="" onClick={@editList}>
                <span className="fa fa-edit" /> Edit
              </a>
            </li>
            <li className="divider" />
            <li role="presentation">
              <a role="menuitem" tabIndex="-1" href="" onClick={@deleteList}>
                <span className="text-danger">
                  <span className="fa fa-trash" /> Delete
                </span>
              </a>
            </li>
          </ul>
        </span>
      </h5>

      <FullHeightPanel offset={offset} className="list-content-container visible-scrollbars">
        <div className={@listContentClass} data-list-id={@state.list._id}>
          { @state.cards.map (card) =>
              <CardOnBoard key={card._id} cardId={card._id} /> }
          <CardAdd onCardAdd={@addCard} />
        </div>
      </FullHeightPanel>
    </div>

  componentDidMount: ->
    scrollingSpeed       = 60
    scrollingSensitivity = 20
    hScrollSpeed         = 11
    hScrollSensitivity   = 105
    boardContainer       = "board-container"
    cardContainer        = "panel"
    placeholder          = "panel card-placeholder"

    node       = React.findDOMNode(@)
    sortableEl = $(node).find(".#{@listContentClass}")
    boardEl    = $(node).parents(".#{boardContainer}")

    sortableEl.sortable
      cursor            : 'move'
      opacity           : 0.8
      tolerance         : 'pointer'
      'ui-floating'     : true
      connectWith       : ".#{@listContentClass}"
      placeholder       : placeholder
      scrollSpeed       : scrollingSpeed
      scrollSensitivity : scrollingSensitivity
      scroll            : false

      stop : (event, ui) =>
        listId = ui.item.parents(".#{@listContentClass}").data().listId
        list   = Lists.findOne(listId)

        movedEl     = ui.item
        movedCardId = movedEl.data()?.cardId
        movedCard   = Cards.findOne(movedCardId) if movedCardId
        prevCardId  = movedEl.prev(".#{cardContainer}").data()?.cardId
        prevCard    = Cards.findOne(prevCardId) if prevCardId
        nextCardId  = movedEl.next(".#{cardContainer}").data()?.cardId
        nextCard    = Cards.findOne(nextCardId) if nextCardId

        # console.log 'sortstop: ', prevCard, nextCard
        # console.log 'movedCard', movedCard

        movedCard.sortOrder = ReactBoards.SortOrder.middle(prevCard?.sortOrder, nextCard?.sortOrder)
        movedCard.listId    = list._id
        movedCard.$save()

        $(movedEl).hide()
        sortableEl.sortable 'cancel'
        $(movedEl).show()

      sort : (event, ui) =>
        # fix for connected lists scrolling issues: http://jsfiddle.net/77YkB/8/ (original fix: http://stackoverflow.com/a/16925318)
        scrollContainer = ui.placeholder[0].parentNode.parentNode
        overflowOffset  = $(scrollContainer).offset()

        if (overflowOffset.top + scrollContainer.offsetHeight) - event.pageY < scrollingSensitivity
          scrollContainer.scrollTop = scrollContainer.scrollTop + scrollingSpeed
        else if event.pageY - overflowOffset.top < scrollingSensitivity
          scrollContainer.scrollTop = scrollContainer.scrollTop - scrollingSpeed

        if (overflowOffset.left + scrollContainer.offsetWidth) - event.pageX < scrollingSensitivity
          scrollContainer.scrollLeft = scrollContainer.scrollLeft + scrollingSpeed
        else if event.pageX - overflowOffset.left < scrollingSensitivity
          scrollContainer.scrollLeft = scrollContainer.scrollLeft - scrollingSpeed
        # end of the scrolling fix

        # horizontal scrolling fix
        x = event.pageX

        # scroll to right
        if boardEl.position().left + boardEl.width() - x <= hScrollSensitivity
          boardEl.scrollLeft boardEl.scrollLeft() + hScrollSpeed
        # scroll to left
        else if x - boardEl.position().left <= hScrollSensitivity
          boardEl.scrollLeft boardEl.scrollLeft() - hScrollSpeed

    sortableEl.disableSelection()

  getMeteorState: ->
    list = Lists.findOne(@props.listId)
    list  : list
    cards : list?.$cards()?.fetch()

  addCard: (card) ->
    cardObject = new Card(card)
    cardObject.listId = @state.list._id
    cardObject.sortOrder = ReactBoards.SortOrder.middle(_.last(@state.cards)?.sortOrder)
    cardObject.$save()

  editList: (event) ->
    event.preventDefault()

  deleteList: (event) ->
    event.preventDefault()
    if confirm "Are you sure you want to delete list '#{@state.list.name}' ?"
      @state.list.$del()


ReactBoards.ListAdd = ReactMeteor.createClass
  render: ->
    Input = ReactBootstrap.Input

    <div>
      <form onSubmit={@addList}>
        <Input ref="name" type='text' placeholder="Add List" />
      </form>
    </div>

  addList: (event) ->
    event.preventDefault()

    name = @refs.name.getValue()
    return unless name

    @props.onListAdd
      name: name

    @refs.name.getInputDOMNode().value = ""
    return

