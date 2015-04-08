ReactBoards.LoginForm = ReactMeteor.createClass
  render: ->
    Input = ReactBootstrap.Input
    Alert = ReactBootstrap.Alert

    <form onSubmit={@_submitHandler}>
      <Input
        type="email"
        ref="email"
        placeholder="Email"
      />
      <Input
        type="password"
        ref="password"
        placeholder="Password"
      />
      <Input
        type="submit"
        value="Sign In"
        className="btn-primary col-xs-12"
      />
      { <Alert bsStyle="danger">{ @state.errorMessage }</Alert> if @state?.errorMessage }
    </form>

  _submitHandler: (event) ->
    event.preventDefault()

    email    = @refs.email.getValue()
    password = @refs.password.getValue()

    Meteor.loginWithPassword email, password, (err) =>
      if (err)
        @setState errorMessage: err.reason
        console.error(err)
      else
        # logged in
        @refs.email.getInputDOMNode().value    = ""
        @refs.password.getInputDOMNode().value = ""
