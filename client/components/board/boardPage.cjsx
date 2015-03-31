ReactBoards.BoardPage = ReactMeteor.createClass
  render: ->
    return <div /> unless @state.board

    Link            = ReactRouter.Link
    List            = ReactBoards.List
    ListAdd         = ReactBoards.ListAdd
    FullHeightPanel = ReactBoards.FullHeightPanel

    classes = classNames 'board-content', "board-content-#{@state.lists.length + 1}"

    offset = ReactBoards.constants.navbarHeight
    offset += ReactBoards.constants.titleHeight
    offset += ReactBoards.constants.footerHeight
    offset += ReactBoards.constants.scrollbarHeight

    <div>
      <h4 className="board-header">
        {@state.board?.name}

        <span className="actions-dropdown dropdown pull-right">
          <button className="btn btn-link dropdown-toggle" type="button" id="actionsMenu" data-toggle="dropdown" aria-expanded="true">
            <span className="fa fa-gears"></span>
          </button>
          <ul className="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="actionsMenu">
            <li role="presentation">
              <a role="menuitem" tabIndex="-1" href="" onClick={@deleteBoard}>
                <span className="text-danger">
                  <span className="fa fa-trash" /> Delete
                </span>
              </a>
            </li>
          </ul>
        </span>
      </h4>

      <div className="board-container visible-scrollbars">
        <FullHeightPanel offset={offset}>
          <div className={classes}>
            { @state.lists.map (list) =>
                <div className="list-container" key={list._id}>
                  <List listId={list._id} />
                </div> }
            <div className="list-container">
              <ListAdd onListAdd={@addList} />
            </div>
          </div>
        </FullHeightPanel>
      </div>
    </div>

  contextTypes:
    router: React.PropTypes.func

  startMeteorSubscriptions: ->
    Meteor.subscribe "board", boardId: @context.router.getCurrentParams().boardId

  getMeteorState: ->
    board = Boards.findOne(@context.router.getCurrentParams().boardId)

    board  : board
    lists  : board?.$lists()?.fetch()
    userId : Meteor.userId()

  deleteBoard: (event) ->
    event.preventDefault()
    if confirm "Are you sure you want to delete board '#{@state.board.name}' ?"
      @state.board.$del()
      @context.router.transitionTo("boards")

  addList: (list) ->
    listObject = new List(list)
    listObject.boardId = @state.board._id
    listObject.$save()
