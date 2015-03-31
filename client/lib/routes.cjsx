Meteor.startup ->
  Router       = ReactRouter
  DefaultRoute = Router.DefaultRoute
  RouteHandler = Router.RouteHandler
  Route        = Router.Route

  Navbar = ReactBoards.Navbar
  Footer = ReactBoards.Footer

  App = ReactMeteor.createClass
    render: ->
      <div>
        <Navbar />

        <div className="container-fluid page-content">
          <RouteHandler/>
        </div>

        <Footer />
      </div>

  routes =
    <Route name="app" path="/" handler={App}>
      <Route name="boards" handler={ReactBoards.BoardsPage}/>
      <Route name="board" path="boards/:boardId" handler={ReactBoards.BoardPage}>
        <Route name="card" path="cards/:cardId" handler={ReactBoards.BoardPage}/>
      </Route>
      <DefaultRoute handler={ReactBoards.HomePage}/>
    </Route>

  Router.run routes, Router.HistoryLocation, (Handler) ->
    React.render <Handler/>, document.body
