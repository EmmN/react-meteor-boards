ReactBoards.LoginButtons = ReactMeteor.createClass
  render: ->
    LoginRegister = ReactBoards.LoginRegister

    Row = ReactBootstrap.Row
    Col = ReactBootstrap.Col

    <li>
      <a href="" onClick={@openDropdown} className="btn btn-link dropdown-toggle" type="button" id="loginMenu" aria-expanded="true">
        { <span>Sign In / Join</span> unless @state.userId }
        { <span>{@state.user.emails[0]}</span> if @state.userId }
        &nbsp; <span className="caret"></span>
      </a>
      <div className="dropdown-menu" style={{minWidth: 250}} role="menu" aria-labelledby="loginMenu">
        <Col xs={12}>
          { <LoginRegister /> unless @state.userId }
          { <a href="" className="btn btn-primary col-xs-12" onClick={@logout}>Sign Out</a> if @state.userId }
        </Col>
      </div>
    </li>

  logout: (event) ->
    event.preventDefault()
    Meteor.logout()

  openDropdown: (event) ->
    event.stopPropagation()
    event.preventDefault()
    $(event.target).closest("li").toggleClass('open')

  getMeteorState: ->
    userId: Meteor.userId()
    user  : Meteor.user()