do (jQuery) ->
  $.fn.extend
    timestack: (options) ->
      defaults =
        click: (content) -> console.log content
        width: '100%'
        parse: (str) -> moment str
        format: (start, end) -> "#{start.format('MMM YYYY')} - #{end.format('MMM YYYY')}"
        color: '#eee'

      options = $.extend defaults, options

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
          obj = {
            start: options.parse($li.attr 'data-start')
            end: options.parse($li.attr 'data-end')
            title: $li.attr 'data-title'
            color: $li.attr('data-color') || options.color
            li: $li
          }

          earliest = obj.start unless earliest && earliest < obj.start
          latest = obj.end unless latest && latest > obj.end

          obj

        diff = latest - earliest

        for i in items
          $li = i.li

          timespan = $("<em>(#{options.format(i.start, i.end)})</em>").addClass('timestack-time')
          titlespan = $("<span>#{i.title} </span>").addClass("timestack-title")

          labelspan = $("<span></span>")
            .addClass('timestack-label')
            .append(titlespan)
            .append(timespan)

          content = $li.children().wrapAll("<div class='timestack-content'></div>").parent().hide()

          width = ((i.end - i.start)/diff * 100).toFixed(2)
          offset = ((i.start - earliest)/diff * 100).toFixed(2)

          $li
            .prepend(labelspan)
            .css("margin-left", "#{offset}%")
            .css("width", "#{width}%")
            .css('background-color', i.color)
            .click(do (content) -> -> options.click(content.children()))



