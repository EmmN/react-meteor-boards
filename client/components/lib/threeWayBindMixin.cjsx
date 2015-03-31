ReactBoards.ThreeWayBindMixin =
  bind3way: (field, value, updateHandler) ->
    @state ||= {}

    @state[field] ||= {}
    @state[field].value = value unless @state[field].hasBeenModified
    @state[field].hasBeenModified = false

    @state[field].update ||= (newVal) =>
      data = {}
      data[field] = _.extend {}, @state[field],
        value           : newVal
        hasBeenModified : true
      @setState data

    @state[field].requestHandler ||= =>
      @state[field].update @refs[field].getValue()
      updateHandler(field, @refs[field].getValue()) if updateHandler