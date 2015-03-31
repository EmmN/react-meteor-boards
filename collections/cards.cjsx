class Card extends Base
  @_collection: -> Cards
  @_fields: ['name', 'description']

  $list: -> Lists.findOne(@listId)

@Card = Card

@Cards = new Mongo.Collection 'cards',
  transform: (card) -> new Card(card)

Cards.allow
  insert: (userId, card) ->
    return false unless card.$list().$board().$hasMember(userId)
    true

  update: (userId, card, fields, modifier) ->
    return false unless card.$list().$board().$hasMember(userId)
    true

  remove: (userId, card) ->
    return false unless card.$list().$board().$hasMember(userId)
    true