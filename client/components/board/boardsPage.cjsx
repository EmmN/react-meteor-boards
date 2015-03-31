ReactBoards.BoardsPage = ReactMeteor.createClass
  render: ->
    BoardAdd  = ReactBoards.BoardAdd
    BoardItem = ReactBoards.BoardItem

    Table = ReactBootstrap.Table

    <div className='boards-list'>
      { <p className="text-muted">Must login before using the app</p> unless Meteor.userId() }
      {
        <Table responsive>
          { <thead><tr><th>Boards</th></tr></thead> if @state.boards.length > 0 }
          <tbody>
            { <tr><td className="text-muted">No boards found! Add your first board now!</td></tr> if @state.boards.length == 0 }

            { @state.boards.map((board) =>
                <tr key={board._id}><td><BoardItem board={board} /></td></tr>
              ) if @state.boards.length > 0 }

            <tr><td><BoardAdd onBoardAdd={@addBoard} /></td></tr>
          </tbody>
        </Table> if Meteor.userId()
      }
    </div>

  startMeteorSubscriptions: -> Meteor.subscribe("boards")

  getMeteorState: ->
    boards: Boards.find({}, {sort: {name: 1}}).fetch()
    userId: Meteor.userId()

  addBoard: (board) ->
    boardObject = new Board(board)
    boardObject.members =
      userId : [Meteor.userId()]
    boardObject.$save()


ReactBoards.BoardItem = ReactMeteor.createClass
  render: ->
    Link = ReactRouter.Link

    DropdownButton = ReactBootstrap.DropdownButton
    MenuItem       = ReactBootstrap.MenuItem

    <div className="board-item">
      <Link to="board" params={{boardId:@props.board._id}} >{ @props.board.name }</Link>

      <span className="actions-dropdown dropdown pull-right">
        <button className="btn btn-link dropdown-toggle" type="button" id="actionsMenu" data-toggle="dropdown" aria-expanded="true">
          <span className="fa fa-gears"></span>
        </button>
        <ul className="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="actionsMenu">
          <li role="presentation">
            <a role="menuitem" tabIndex="-1" href="" onClick={@editBoard}>
              <span className="fa fa-edit" /> Edit
            </a>
          </li>
          <li className="divider" />
          <li role="presentation">
            <a role="menuitem" tabIndex="-1" href="" onClick={@deleteBoard}>
              <span className="text-danger">
                <span className="fa fa-trash" /> Delete
              </span>
            </a>
          </li>
        </ul>
      </span>
    </div>

  editBoard: (event) ->
    event.preventDefault()

  deleteBoard: (event) ->
    event.preventDefault()
    if confirm "Are you sure you want to delete board '#{@props.board.name}' ?"
      @props.board.$del()


ReactBoards.BoardAdd = ReactMeteor.createClass
  addBoard: (event) ->
    event.preventDefault()

    name = React.findDOMNode(@refs.name).value.trim()
    return unless name

    @props.onBoardAdd
      name: name

    React.findDOMNode(@refs.name).value = ""
    return

  render: ->
    <form className="board-add form" onSubmit={@addBoard}>
      <input type="text" ref="name" placeholder="Add board" className="form-control" />
    </form>