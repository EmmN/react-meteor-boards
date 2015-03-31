class List extends Base
  @_collection: -> Lists

  $board: -> Boards.findOne(@boardId)

  $cards: -> Cards.find {listId: @_id}, {sort: {sortOrder: 1}}

  $beforeDelete: ->
    cards = @$cards().fetch()
    _.each cards, (card) -> card.$del()

@List = List

@Lists = new Mongo.Collection 'lists',
  transform: (list) -> new List(list)

Lists.allow
  insert: (userId, list) ->
    return false unless list.$board().$hasMember(userId)
    true

  update: (userId, list, fields, modifier) ->
    return false unless list.$board().$hasMember(userId)
    true

  remove: (userId, list) ->
    return false unless list.$board().$hasMember(userId)
    true