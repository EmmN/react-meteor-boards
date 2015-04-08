ReactBoards.RegisterForm = ReactMeteor.createClass
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
        value="Create an account"
        className="btn-primary col-xs-12"
      />
      { <Alert bsStyle="danger">{ @state.errorMessage }</Alert> if @state?.errorMessage }
    </form>

  _submitHandler: (event) ->
    event.preventDefault()

    email    = @refs.email.getValue()
    password = @refs.password.getValue()

    Accounts.createUser {email: email, password: password}, (err) =>
      if (err)
        console.error(err)
        @setState errorMessage: err.reason
      else
        # account created and login succeded
        @refs.email.getInputDOMNode().value    = ""
        @refs.password.getInputDOMNode().value = ""
