Meteor.publishComposite 'board', (options) ->
  find     : ->
    Boards.find
      _id              : options.boardId
      'members.userId' : @userId
  children : [
    {
      find     : (board) -> board.$lists()
      children : [
        {
          find: (list) -> list.$cards()
        }
      ]
    }
  ]