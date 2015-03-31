class Base
  @_collection: -> console.error "Add collection"
  @_fields: []

  @defaults: {}

  constructor: (data) -> _.extend @, @constructor.defaults, data
  $beforeDelete: -> return

  $del: ->
    @$beforeDelete()
    @constructor._collection().remove(@_id)

  $extractData: ->
    existingFields = _.omit @, (value, key) -> _.startsWith(key, "$") || key == "_id"
    _.each @constructor._fields, (field) -> existingFields[field] ||= null
    existingFields

  $save: ->
    @userId ||= Meteor.userId()
    if @_id
      @constructor._collection().update(@_id, {$set: @$extractData()})
    else
      @createdAt ||= new Date
      @_id = @constructor._collection().insert(@$extractData())
    @

  $update: (data) ->
    return false unless @_id
    @constructor._collection().update(@_id, {$set: data})

  $reset: ->
    data = @constructor._collection().findOne(@_id)
    _.extend @, data

  $duplicate: ->
    newItemData = @$extractData()
    newItemData.name = "Copy - " + newItemData.name
    newItem = new @constructor(newItemData)
    newItem.$save()
    newItem

@Base = Base