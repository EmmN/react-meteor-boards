ReactBoards.HomePage = ReactMeteor.createClass
  render: ->
    <div>
      <h1> Welcome to React Meteor Boards</h1>

      <p>
      A simple board build with react and meteor.
      This is just a test app to see what I can do with React + Meteor.
      </p>


      <h2>Things Done</h2>
      <ul>
        <li>integrate Blaze templates in React components (accounts-ui)</li>
        <li>router</li>
        <li>drag and drop with jQueryUI (vertical and horizontal scroll fixes)</li>
        <li>three way binding on input / textarea (not sure it's a good solution)</li>
      </ul>

      <p><a href="https://github.com/EmmN/react-meteor-boards">https://github.com/EmmN/react-meteor-boards</a></p>
    </div>
