# we need Meteor.startup because we need ReactBootstrap to be loaded so we can use mixins
Meteor.startup ->
  ReactBoards.CardOnBoard = ReactMeteor.createClass
    render: ->
      return <div /> unless @state.card
      Panel = ReactBootstrap.Panel

      <Panel onClick={@toggleModal} data-card-id={@state.card._id}>
        { @state.card.name }
        <span className="actions-dropdown dropdown pull-right" onClick={@stopPropagation}>
          <button className="btn btn-link dropdown-toggle" type="button" id="actionsMenu" data-toggle="dropdown" aria-expanded="true">
            <span className="fa fa-gears"></span>
          </button>
          <ul className="dropdown-menu dropdown-menu-right" role="menu" aria-labelledby="actionsMenu">
            <li role="presentation">
              <a role="menuitem" tabIndex="-1" href="" onClick={@deleteCard}>
                <span className="text-danger">
                  <span className="fa fa-trash" /> Delete
                </span>
              </a>
            </li>
          </ul>
        </span>

      </Panel>

    contextTypes:
      router: React.PropTypes.func

    mixins: [ReactBootstrap.OverlayMixin]

    getMeteorState: ->
      card = Cards.findOne(@props.cardId)
      card: card

    getInitialState: ->
      isModalOpen : @context.router.getCurrentParams().cardId == @props.cardId

    renderOverlay: ->
      Modal  = ReactBootstrap.Modal
      Button = ReactBootstrap.Button

      CardOnModal = ReactBoards.CardOnModal

      return <span/> unless @state.isModalOpen

      <Modal bsStyle='primary' bsSize="large" onRequestHide={@toggleModal}>
        <div className='modal-body'>
          <CardOnModal cardId={@state.card._id} />
        </div>
        <div className='modal-footer'>
          <Button bsStyle="danger" onClick={@deleteCard}>
            <span className="fa fa-trash" /> Delete
          </Button>
          <Button onClick={@toggleModal}>Close</Button>
        </div>
      </Modal>

    toggleModal: (event) ->
      event?.preventDefault()
      if @state.isModalOpen
        @context.router.transitionTo "board", {
          boardId : @state.card.$list().boardId
        }
      else
        @context.router.transitionTo "card", {
          boardId : @state.card.$list().boardId
          cardId  : @state.card._id
        }
      @setState
        isModalOpen : !@state.isModalOpen

    stopPropagation: (event) ->
      event?.preventDefault()
      event?.stopPropagation()

    deleteCard: (event) ->
      event?.preventDefault()
      if confirm "Are you sure you want to delete this card ?"
        @state.card.$del()


  ReactBoards.CardAdd = ReactMeteor.createClass
    render: ->
      Input = ReactBootstrap.Input

      <div>
        <form onSubmit={@addCard}>
          <Input ref="name" type='text' placeholder="Add Card" />
        </form>
      </div>

    addCard: (event) ->
      event.preventDefault()

      name = @refs.name.getValue()
      return unless name

      @props.onCardAdd
        name: name

      @refs.name.getInputDOMNode().value = ""
      return

