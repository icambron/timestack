do (jQuery) ->

  $.fn.extend
    timestack: (options) ->
      defaults =
        click: null
        parse: (s) -> moment(s)
        renderDates: (item) ->
          dateFormat = @dateFormats[options.span]
          startFormated = item.start.format dateFormat
          endFormated = if item.tilNow then '' else item.end.format dateFormat
          @formatRange startFormated, endFormated
        formatRange: (startStr, endStr) -> "#{startStr} - #{endStr}"
        span: 'year'
        dateFormats:
          year: 'MMM YYYY'
          month: 'MMM DD'
          day: 'MMM DD'
          hour: 'h:mm a'
        intervalFormats:
          year: 'YYYY'
          month: 'MMM YYYY'
          day: 'MMM DD'
          hour: 'h:mm a'

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
          i = {
            tilNow: !endStr
            start: options.parse($li.attr 'data-start')
            end: options.parse endStr
            title: $li.contents().filter(-> @nodeType == 3).remove().text()
            color: $li.attr('data-color')
            li: $li
          }

          earliest = i.start.clone() unless earliest && earliest < i.start
          latest = i.end.clone() unless latest && latest > i.end
          i

        earliest.startOf options.span
        unless latest.valueOf() == latest.clone().startOf(options.span).valueOf()
          latest.endOf options.span


        diff = latest - earliest

        for i in items
          $li = i.li

          i.timeDisplay = options.renderDates i

          timespan = $("<em>(#{i.timeDisplay})</em>").addClass('timestack-time')
          titlespan = $("<span>#{i.title} </span>").addClass("timestack-title")

          labelspan = $("<span></span>")
            .addClass('timestack-label')
            .append(titlespan)
            .append(timespan)

          i.content = $li
            .children()
            .wrapAll("<div class='timestack-content'></div>")
            .parent()
            .hide()
            .children()

          width = ((i.end - i.start)/diff * 100).toFixed(2)
          offset = ((i.start - earliest)/diff * 100).toFixed(2)

          $li
            .prepend(labelspan)
            .css("margin-left", "#{offset}%")
            .css("width", "#{width}%")
            .click(do (i) -> -> options.click i)

          $li.css('background-color', i.color) if i.color
          $li.css('cursor', 'pointer') if options.click

        dates = between earliest, latest
        width = (100/dates.length).toFixed(2) + "%"
        format = options.intervalFormats[options.span]
        $intervals = $("<ul></ul>").addClass("intervals")
        for date in dates
          $("<li></li>")
            .text(date.format(format))
            .css('width', width)
            .appendTo($intervals)
        $obj.append($intervals)
