---
layout: default
title: Timestack
---

Timestack
=========

Timestack is a simple jQuery plugin for generating pretty, clickable timelines for the web.

###Introducing Timestack
Check it out:

<div id='hourly'></div>

Here's how it works:

{% highlight javascript %}
$('#hourly').timestack({
  span: 'hour',
  data: [
    {
      title: 'Bob OOO',
      start: '2012-08-26T09:00',
      end: '2012-08-26T17:00',
      color: 'rgb(149, 203, 255)'
    },
    {
      title: 'Meeting',
      start: '2012-08-26T09:00',
      end: '2012-08-26T10:00',
      color: 'rgb(255, 149, 192)'
    },
    {
      title: 'Lunch',
      start: '2012-08-26T12:00',
      end: '2012-08-26T13:00',
      color: 'rgb(151, 255, 177)'
    },
    {
      title: 'Code review',
      start: '2012-08-26T12:30',
      end: '2012-08-26T15:30',
      color: 'rgb(255, 149, 192)'
    }
  ]
});
{% endhighlight %}

And have a div on your page like `<div id="timeline"></div>`. That's it!

Timestack is hosted on [Github](https://github.com/icambron/timestack).

###Getting started 

Timestack relies on [moment.js](http://momentjs.com/) and [jQuery](http://jquery.com) to do its job. It also comes with a stylesheet that makes it look the way it does. The two Timestack files you need are <a
href='files/timestack.min.js'>timestack.min.js</a> (or alternatively,
the non-minified <a href='files/timestack.js'>timestack.js</a>) and the
<a href='files/timestack.css'>timestack.css</a> stylesheet.

Either download those, or just reference them directly:

{% highlight html %}
<script src='http://code.jquery.com/jquery-1.8.0.min.js'></script>
<script src='http://icambron.github.com/timestack/files/moment.min.js'></script>
<script src='http://icambron.github.com/timestack/files/timestack.min.js'></script>
<link rel='stylesheet' type='text/css' href='http://icambron.github.com/timestack/files/timestack.css'>
{% endhighlight %}

Then you're good to go! You can read the docs below, or just check out the <a href='files/tutorial.html'>tutorial</a>.

Some important stuff you should know:

 * Those dates in the HTML attributes are [ISO-8601](http://en.wikipedia.org/wiki/ISO_8601), but you can actually use anything that `moment()` will [parse](http://momentjs.com/docs/#/parsing/javascript-date-object/), or even an actual moment object. And you can customize that parsing (see below).

 * You don't have to specify an end time. Timestack will treat the time as right now, but won't display the time in the timeline.

 * The background color will default to what's in the stylesheet unless you override with the `color` property. The color is applied as CSS, so you can use hash codes or any color names the browser knows.

###Different spans

Timestack needs to know how long of time scales we're talking about. Use the `span` option to tell Timestack how to show dates and how to set up the intervals at the bottom. It defaults to "year", but you might want "hour", "day", or "month", depending on how long your timeline items are. Just set it when you call `timestack()`:

{% highlight javascript %}
$('#timeline').timestack({
  span: 'day', 
  data: [/*...*/]
});
{% endhighlight %}

That way you can make generate stuff like this:

<div id='daily'></div>

###Clickability

If you specify a click callback, the timeline items will become clickable:

{% highlight javascript %}
$('#clicky').timestack({
  span: 'month',
  click: function(data){alert(data.title);},
  data: [/*...*/]
});
{% endhighlight %}

<div id='clicky'></div>

The `data` passed back is just the object you passed in, with a few enhancements:

{% highlight javascript %}
{
  //stuff you passed in
  start: moment,                       //now wrapped as a moment object
  end: moment,
  title: 'Contact Networks',
  color: '#00000',

  //stuff added by timestack
  tilNow: false,                       //does the item have an end time?
  timeDisplay: 'Dec 2005 - Nov 2007'   //the date/time range rendered on the item

  //any other properties you set on the JS object
handlers
}
{% endhighlight %}

Because we pass through arbitrary properties, you can use that to pass
additional content to your click handlers.

###Customizing Timestack

Timestack allows you to override a lot of its functionality. Here are the most common options with their defaults:

{% highlight javascript %}
{
  click: null,                         //looks like function(data){}
  span: 'year',                        //what range of time are we looking at? 'year', 'month', 'day', and 'hour' are implemented
  parse: function(string){},           //how to parse the start/end attributes. Must return a moment instance
  formatRange: function(start, end){}  //takes two string representing dates and returns a string representing that date range. Defaults to putting a dash between them.

  dateFormats: {                       //how to render times for various spans. These are moment formatting tokens.
    year: 'MMM YYYY',
    month: 'MMM DD',
    day: 'MMM DD',
    hour: 'h:mm a'
  },

  intervalFormats: {                   //how to render the intervals for various spans. These are moment formatting tokens.
    year: 'YYYY'
    month: 'MMM YYYY'
    day: 'MMM DD'
    hour: 'h:mm a'
  }
  
  data: []
}
{% endhighlight %}

You should also feel free to edit the stylesheet to change fonts, colors, etc. It's [pretty simple](https://github.com/icambron/timestack/blob/master/files/timestack.css).

###Progressive enhancement

Mostly for reverse compatibility with an earlier version of Timestack, you can construct a timeline out of existing LIs instead of passing in a data element. The DOM looks like this:

{% highlight html %}
<div id='timeline'>
  <ul>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T17:00' data-color='#95e6ff'>Bob OOO</li>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T10:30' data-color='#ff95c0'>Meeting</li>
    <li data-start='2012-08-26T12:00' data-end='2012-08-26T13:00' data-color='#97ffb1'>Lunch</li>
    <li data-start='2012-08-26T13:00' data-end='2012-08-26T14:30' data-color='#ff95c0'>
      Code review
      <p>Gotta find out if everyone is happy with this timeline component.<p>
    </li>
  </ul>
</div>
{% endhighlight %}

Then just call without the data element:

{% highlight javascript %}
$('#hourly').timestack({ span: 'hour' });
{% endhighlight %}

The immediate text node under the `li` is used as the `title` property. Any child nodes (as in the `<p>` in the example), get pushed into a `content` property on the data object; that's useful when handling click events.

###Using Timestack with Twix

One option not included above is the `renderDates` option that allows
you to override the way Timestack renders time ranges at a lower level.
The default implementation handles all the stuff about checking whether
we're looking at days or years and formatting accordingly, so you're a
bit on your own if you override it. But one great use case for this is using a third-party library to format
the time ranges. For example, here's how to use Timestack with [Twix](https://icambron.github.io/twix.js):

{% highlight javascript %}
$('#twix').timestack({
  span: 'hour',

  renderDates: function(item){
    return moment.twix(item.start, item.end).format({showDate: false})
  },

  data: [/*...*/]
});
{% endhighlight %}

<div id='twix'></div>

Notice the more time subtle formatting. You can see a full example of this [here](https://github.com/icambron/timestack/blob/master/examples/twix.html).

##Credits

Much of the inspiration and CSS comes from Matt Bango's [Pure CSS
Timeline](http://mattbango.com/notebook/web-development/pure-css-timeline/). This would have taken a lot longer and looked a lot worse without his work. There's also Tim Wood's excellent [Moment](http://momentjs.com/) library, which made this a lot easier to build. I'd also like to thank Bota Box Wine, because I drank like eight glasses of it while I wrote this.
