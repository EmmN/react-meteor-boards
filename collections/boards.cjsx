class Board extends Base
  @_collection: -> Boards

  $hasMember: (userId) ->
    _.find(@members.userId, (userId) -> Meteor.userId() == userId)

  $beforeDelete: ->
    lists = @$lists().fetch()
    _.each lists, (list) -> list.$del()

  $lists: -> Lists.find {boardId: @_id}

@Board = Board

@Boards = new Mongo.Collection 'boards',
  transform: (board) -> new Board(board)



# Modify data from the client directly in the DB
# e.g. Boards.find().fetch()[0].$del()
Boards.allow
  insert: (userId, board) ->
    return false unless board.$hasMember(userId)
    true

  update: (userId, board, fields, modifier) ->
    return false unless board.$hasMember(userId)
    true

  remove: (userId, board) ->
    return false unless board.$hasMember(userId)
    true



# # Modify data using methods
# # e.g. Meteor.call("deleteBoard", boardId)
# Meteor.methods
#   addBoard: (board) ->
#     # Make sure the user is logged in before inserting a task
#     throw new (Meteor.Error)('not-authorized') if !Meteor.userId()

#     boardData = _.extend {}, board,
#       members :
#         userId : [Meteor.userId()]

#     board = new Board(boardData)
#     board.$save()

#   deleteBoard: (boardId) ->
#     throw new (Meteor.Error)('not-authorized') if !Meteor.userId()

#     board = Boards.findOne boardId
#     throw new (Meteor.Error)('not-found') unless board
#     throw new (Meteor.Error)('not-authorized') unless board.$hasMember(Meteor.userId())

#     board.$del()
