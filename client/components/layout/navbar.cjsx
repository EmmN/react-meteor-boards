ReactBoards.NavLink = ReactMeteor.createClass
  contextTypes:
    router: React.PropTypes.func

  render: ->
    Link = ReactRouter.Link

    { router } = @context
    isActive   = router.isActive(@props.to, @props.params, @props.query)
    className  = if isActive then 'active' else ''
    <li className={className}>
      <Link {...@props} />
    </li>


ReactBoards.Navbar = ReactMeteor.createClass
  getMeteorState: ->
    userId: Meteor.userId()

  componentDidMount: -> @renderMeteorLoginButtons()

  renderMeteorLoginButtons: ->
    node = @getDOMNode()
    Blaze.remove @MeteorLoginButtonsView if @MeteorLoginButtonsView
    @MeteorLoginButtonsView = Blaze.render(Template._loginButtons, $(node).find(".loginButtons")[0])

  render: ->
    Navbar         = ReactBootstrap.Navbar
    Nav            = ReactBootstrap.Nav
    NavItem        = ReactBootstrap.NavItem
    CollapsableNav = ReactBootstrap.CollapsableNav
    MenuItem       = ReactBootstrap.MenuItem

    NavLink        = ReactBoards.NavLink

    <Navbar brand={<a target="_blank" href="https://github.com/EmmN/react-meteor-boards">React-Meteor-Boards</a>} fluid toggleNavKey={0}>
      <CollapsableNav eventKey={0}>
        <Nav navbar>
          <NavLink to="/">Home</NavLink>
          { <NavLink to="boards">Boards</NavLink> if Meteor.userId() }
        </Nav>
        <ul className="nav navbar-nav navbar-right loginButtons" />
      </CollapsableNav>
    </Navbar>

