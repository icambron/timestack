do (jQuery) ->

  capitalize = (s) -> s.charAt(0).toUpperCase() + s.slice(1)

  $.fn.extend
    timestack: (options) ->
      defaults =
        click: (data) -> console.log data.content
        width: '100%'
        parse: (str) -> moment str
        dateFormat: 'MMM YYYY'
        displayFormat: (start, end) -> "#{start} - #{end}"
        color: '#eee'
        span: 'year'
        spanFormats:
          year: 'YYYY'
          month: 'MMM YYYY'
          day: 'MMM DD, YYYY'

      options = $.extend defaults, options

      between = (start, end) ->
        results = []
        index = start.clone().startOf(options.span)
        while index < end
          results.push index.clone()
          index.add(options.span + 's', 1)
        results

      @each ->
        $obj = $ @

        $ul = $obj.children('ul')
        $ul
          .css('width', options.width)
          .addClass('timestack-events')

        earliest = null
        latest = null

        items = $ul.children('li').map ->
          $li = $ @
          endStr = $li.attr 'data-end'
          obj = {
            tilNow: !endStr
            start: options.parse($li.attr 'data-start')
            end: options.parse(endStr)
            title: $li.attr 'data-title'
            color: $li.attr('data-color') || options.color
            li: $li
          }

          earliest = obj.start.clone() unless earliest && earliest < obj.start
          latest = obj.end.clone() unless latest && latest > obj.end

          obj

        earliest.startOf options.span
        latest.endOf options.span

        diff = latest - earliest

        for i in items
          $li = i.li

          startFormat = i.start.format options.dateFormat
          endFormat = if i.tilNow then '' else i.end.format options.dateFormat
          i.timeDisplay = options.displayFormat(startFormat, endFormat)

          timespan = $("<em>(#{i.timeDisplay})</em>").addClass('timestack-time')
          titlespan = $("<span>#{i.title} </span>").addClass("timestack-title")

          labelspan = $("<span></span>")
            .addClass('timestack-label')
            .append(titlespan)
            .append(timespan)

          i.content = $li.children().wrapAll("<div class='timestack-content'></div>")
          i.content.parent().hide()

          width = ((i.end - i.start)/diff * 100).toFixed(2)
          offset = ((i.start - earliest)/diff * 100).toFixed(2)

          $li
            .prepend(labelspan)
            .css("margin-left", "#{offset}%")
            .css("width", "#{width}%")
            .css('background-color', i.color)
            .click(do (i) -> -> options.click i)

        dates = between earliest, latest
        width = (1/dates.length * 100).toFixed(2) - 0.03 + "%"
        format = options.spanFormats[options.span]
        $intervals = $("<ul></ul>").addClass("intervals")
        for date in dates
          $("<li></li>")
            .text(date.format(format))
            .css('width', width)
            .appendTo($intervals)
        $obj.append($intervals)

