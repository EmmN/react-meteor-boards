ReactBoards.Footer = ReactMeteor.createClass
  render: ->
    Navbar = ReactBootstrap.Navbar

    <Navbar fluid fixedBottom className="footer">
      <span className="text-muted">
        by <a href="https://github.com/EmmN/">EmmN</a>
        <a className="pull-right" href="https://github.com/EmmN/react-meteor-boards">
          <span className="fa fa-github"></span>
        </a>
      </span>
    </Navbar>