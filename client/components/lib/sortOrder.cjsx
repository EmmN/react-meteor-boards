ReactBoards.SortOrder =
    FIRST: '000'
    LAST : 'zzz'
    BASE : 36

    padding: (string) ->
      string = string.toString()
      if string.length > 4
        return string
      Array(4 - string.length).join('0') + string

    string: (integer) ->
      @padding integer.toString(@BASE)

    formatted: (sort_order) ->
      self = @
      if typeof(sort_order) is 'string'
        sort_order = [ sort_order.substr(0, 3) ]
      sort_order = sort_order or []
      $.map(sort_order, (i) -> self.padding(i)).join ''

    chunk: (string) ->
      self = @
      if typeof(string) != 'array'
        string = [ string ]
      [].concat.apply [], string.map((el) -> el.match(/(.{1,3})/g).map (s) -> self.padding(s))

    middle: (sort_order1, sort_order2) ->
      self = @
      sort_order1 ||= self.FIRST
      sort_order2 ||= self.LAST

      new_sort_order = []
      # make sure these are arrays of three chars items
      sort_order1 = self.chunk(sort_order1)
      sort_order2 = self.chunk(sort_order2)
      i = 0
      while i <= Math.max(sort_order1.length, sort_order2.length)
        start_value = sort_order1[i] or self.FIRST
        end_value   = sort_order2[i] or self.LAST
        base        = self.BASE
        diff        = parseInt(end_value, base) - parseInt(start_value, base)
        interval    = if diff > 20 then 10 else 1
        a           = parseInt(start_value, base) + interval
        b           = parseInt(end_value, base) - interval

        if start_value == self.FIRST and end_value == self.LAST
          sort_order_item = self.string(parseInt(end_value, self.BASE) / 10)
        else if diff > 20 and end_value == self.LAST and a < parseInt(end_value, base)
          sort_order_item = a.toString(base)
        else if (start_value == self.FIRST or diff <= 20) and b > parseInt(start_value, base)
          sort_order_item = b.toString(base)
        else
          sort_order_item = self.string(parseInt((parseInt(start_value, base) + parseInt(end_value, base)) / 2))

        if parseInt(sort_order_item, base) > parseInt(start_value, base)
          new_sort_order.push self.formatted(sort_order_item)
          if parseInt(end_value, base) > parseInt(sort_order_item, base)
            return @formatted(new_sort_order)
        else
          new_sort_order.push self.formatted(start_value)
        i++

      return @formatted(new_sort_order)
