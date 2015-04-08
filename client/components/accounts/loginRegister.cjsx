ReactBoards.LoginRegister = ReactMeteor.createClass
  render: ->
    LoginForm    = ReactBoards.LoginForm
    RegisterForm = ReactBoards.RegisterForm

    if @state.form == 'login'
      <div>
        <LoginForm />
        <a href="" onClick={@register}>Create Account</a>
      </div>
    else if @state.form == 'register'
      <div>
        <RegisterForm />
        <a className="btn btn-default col-xs-12" href="" onClick={@login}>Cancel</a>
      </div>

  getInitialState: ->
    form: 'login'

  login: (event) ->
    event.preventDefault()
    @setState form: 'login'

  register: (event) ->
    event.preventDefault()
    @setState form: 'register'