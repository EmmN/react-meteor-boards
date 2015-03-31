ReactBoards.CardOnModal = ReactMeteor.createClass
  mixins: [ReactBoards.ThreeWayBindMixin]

  render: ->
    Input = ReactBootstrap.Input

    TextareaAutosize = ReactBoards.TextareaAutosize

    <div>
      <h4>
        <TextareaAutosize
          ref="name"
          placeholder='Card title...'
          className="unstyled form-control"
          value={@state.name.value}
          onChange={@state.name.requestHandler}
        />
      </h4>

      <div>
        <TextareaAutosize
          label='Description'
          ref="description"
          placeholder='Card description...'
          className="unstyled form-control"
          value={@state.description.value}
          onChange={@state.description.requestHandler}
        />
      </div>
    </div>

  getMeteorState: ->
    card = Cards.findOne(@props.cardId)

    _.each card.$extractData(), (fieldValue, fieldName) =>
      @bind3way fieldName, fieldValue, (field, value) =>
        data = {}
        data[field] = value
        @state.card.$update data

    card: card