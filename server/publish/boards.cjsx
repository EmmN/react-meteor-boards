Meteor.publish 'boards', ->
  return @ready() unless @userId

  Boards.find
    'members.userId' : @userId