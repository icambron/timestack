###
Timestack
http://icambron.github.com/timestack
Copyright 2012 Isaac Cambron
Released under the MIT license, license here: https://github.com/icambron/timestack/blob/master/Readme.markdown
###
do (jQuery) ->
  $ = jQuery

  $.fn.extend
    timestack: (options) ->
      defaults =
        click: ->
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

      throw "#{options.span} is not a valid span option" unless ['year', 'month', 'day', 'hour'].indexOf(options.span) > -1

      parseDom = ($obj) ->
        $ul = $obj.children('ul:not(.timestack-events)')

        return [] if $ul.length == 0

        [
          $ul
          $ul.children('li').map ->
            $li = $ @
            i = {
              start: $li.attr 'data-start'
              end: $li.attr 'data-end'
              title: $li.contents().filter(-> @nodeType == 3).remove().text()
              color: $li.attr('data-color')
              li: $li
              content: $li.children().remove()
            }
        ]

      useData = ($obj, items) ->
        $obj.empty()
        $ul = $("<ul></ul>")
        $obj.append $ul
        [$ul, items]

      findEnds = (items) ->
        earliest = null
        latest = null

        for i in items

          i.start = options.parse(i.start)
          i.tilNow = !i.end
          i.end = options.parse(i.end)

          throw 'Start times must be before end times' unless i.start <= i.end

          earliest = i.start.clone() unless earliest && earliest < i.start
          latest = i.end.clone() unless latest && latest > i.end

        [earliest, latest]

      between = (start, end) ->
        results = []
        index = start.clone().startOf(options.span)
        while index < end
          results.push index.clone()
          index.add(options.span + 's', 1)
        results

      @each ->
        $obj = $ @

        [$ul, items] = parseDom $obj
        [$ul, items] = useData($obj, options.data) unless $ul

        throw "Timestack requires either a data object or a UL for progressive enhancement." unless $ul

        $ul
          .css('width', options.width)
          .addClass('timestack-events')

        [earliest, latest] = findEnds items

        earliest.startOf options.span
        unless latest.valueOf() == latest.clone().startOf(options.span).valueOf()
          latest.endOf options.span

        diff = latest - earliest

        for i in items
          $li = i.li

          unless $li
            $li = $("<li></li>")
            $ul.append $li

          i.timeDisplay = options.renderDates i

          timespan = $("<em>(#{i.timeDisplay})</em>").addClass('timestack-time')
          titlespan = $("<span>#{i.title} </span>").addClass("timestack-title")

          labelspan = $("<span></span>")
            .addClass('timestack-label')
            .append(titlespan)
            .append(timespan)

          width = ((i.end - i.start)/diff * 100).toFixed(2)
          offset = ((i.start - earliest)/diff * 100).toFixed(2)

          $li
            .prepend(labelspan)
            .css("margin-left", "#{offset}%")
            .css("width", "#{width}%")
            .click(do (i) -> -> options.click i)

          $li.css('background-color', i.color) if i.color
          $li.css('cursor', 'pointer') if options.click

          $li.addClass(i.class) if i.class?

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
