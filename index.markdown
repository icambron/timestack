---
layout: default
title: Timestack
---

Timestack
=========

Timestack is a simple jQuery plugin for generating pretty, clickable timelines for the web.

###Introducing Timestack
Check it out:

<div id='hourly'>
  <ul>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T17:00' data-color='#ADC3DC'>Bob OOO</li>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T10:30' data-color='#F2C1D3'>Meeting</li>
    <li data-start='2012-08-26T12:00' data-end='2012-08-26T13:00' data-color='#99FF66'>Lunch</li>
    <li data-start='2012-08-26T13:00' data-end='2012-08-26T14:30' data-color='#F2C1D3'>Code review</li>
  </ul>
</div>

See a fuller demo with clickability [in the tutorial]("tutorial.html").

How'd we do that? You start with some markup that looks like this:

{% highlight html %}
<div id='timeline'>
  <ul>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T17:00' data-color='#ADC3DC'>Bob OOO</li>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T10:30' data-color='#F2C1D3'>Meeting</li>
    <li data-start='2012-08-26T12:00' data-end='2012-08-26T13:00' data-color='#99FF66'>Lunch</li>
    <li data-start='2012-08-26T13:00' data-end='2012-08-26T14:30' data-color='#F2C1D3'>Code review</li>
  </ul>
</div>
 {% endhighlight %}

Then do this:

{% highlight javascript %}
$('#timeline').timestack({span: 'hour'});
{% endhighlight %}

That's it!

Timestack is hosted on [Github](https://github.com/icambron/timestack).

###Getting started 

Timestack relies on [moment.js](http://momentjs.com/) and [jQuery](http://jquery.com) to do its job. It also comes with a stylesheet that makes it look the way it does. So you'll need this in your pages `<head>`:

{% highlight html %}
<script src='http://code.jquery.com/jquery-1.8.0.min.js'></script>
<script src='https://raw.github.com/timrwood/moment/1.7.0/min/moment.min.js'></script>
<script src='https://raw.github.com/icambron/timestack/master/files/timestack.min.js'></script>
<link rel='stylesheet' type='text/css' href='https://raw.github.com/icambron/timestack/master/files/timestack.css'/>
{% endhighlight %}

Then you're good to go! You can read the docs below, or just check out the [tutorial](tutorial.html).

Some important stuff you should know:

 * Those dates in the HTML attributes are [ISO-8601](http://en.wikipedia.org/wiki/ISO_8601). You can actually use anything that `moment()` will [parse](http://momentjs.com/docs/#/parsing/javascript-date-object/), and you can even customize that parsing (see below).

 * You don't have to specify and end time. Timestack will treat the time as right now, but won't display the time in the timeline.

 * The background color will default to what's in the stylesheet unless you override with the `data-color` attribute. The color is applied as CSS, so you can use hash codes or any color names the browser knows.

###Different spans

Timestack needs to know how long of time scales we're talking about. Use the `span` option to tell Timestack how to show dates and how to set up the intervals at the bottom. It defaults to "year", but you might want "hour", "day", or "month", depending on how long your timeline items are. Just set it when you call `timestack()`:

{% highlight javascript %}
$('#timeline').timestack({span: 'day'});
{% endhighlight %}

That way you can make generate stuff like this:

<div id='daily'>
  <ul>
    <li data-start='2012-08-26' data-end='2012-08-28' data-color='#99FF66'>Vacation!</li>
    <li data-start='2012-08-15' data-end='2012-08-20' data-color='#F2C1D3'>Convention</li>
    <li data-start='2012-08-21' data-end='2012-08-25' data-color='#ADC3DC'>Meetings</li>
    <li data-start='2012-08-07' data-end='2012-08-16' data-color='#F1C27B'>Sprint</li>
    <li data-start='2012-08-19' data-end='2012-08-26' data-color='#F1C27B'>Sprint</li>
  </ul>
</div>

###Content

You might want to include more information with each timeline item. Just add HTML nodes inside each LI, like so:

{% highlight html %}
<div id='#timestack'>
  <ul>
    <li data-start='8/15/1996' data-end='6/01/1998'>
     An item title
     <p>This is content.</p>
    </li>
    <li data-start='9/1/2000' data-end='6/15/2004'>
      Another title
      <div>
        <p>This is more content! It's arbitrary <strong>HTML</strong></p>
      <div>
    </li>
  </ul>
</div>
{% endhighlight %}

Those HTML nodes  aren't rendered in the timeline, but Timestack will pass them back to you in the click callback (see below).

###Clickability

If you specify a click callback, the timeline items will become clickable:

{% highlight javascript %}
$('#timeline').timestack({
  span: 'month',
  click: function(data){alert(data.title);}
});
{% endhighlight %}

<div id='clicky'>
  <ul>
    <li data-start='2012-08-15' data-end='2012-10-28' data-color='#ADC3DC'>Spain</li>
    <li data-start='2012-11-01' data-end='2013-02-28' data-color='#F2C1D3'>France</li>
    <li data-start='2013-03-01' data-end='2013-04-30' data-color='#99FF66'>Italy</li>
  </ul>
</div>

The `data` passed to the callback is an object that looks like this:

{% highlight javascript %}
{
  tilNow: false,                       //does the item have an end time?
  start: moment,                       //a moment object representing the start time
  end: moment,                         //a moment object representing the end time
  title: 'Contact Networks',           //the text child of the LI, rendered as the title of the item
  color: '#00000',                     //the value of the data-color attribute
  content: jquery,                     //a jquery object containing the LI's DOM children
  timeDisplay: 'Dec 2005 - Nov 2007'   //the date/time range rendered on the item
}
{% endhighlight %}


Combined with content (see above), you can use this callback to push content into another div to show details about what the user clicked on:

{% highlight javascript %}
$('#timeline').timestack({
  click: function(data){
    $('#title').text(data.title);
    $('#dates').text(data.timeDisplay);
    $('#content').empty().append(data.content);
  }
});
{% endhighlight %}

The [tutorial page](tutorial.html) shows this in action.

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
{% endhighlight %}

You should also feel free to edit the stylesheet to change fonts, colors, etc. It's [pretty simple](https://github.com/icambron/timestack/blob/master/files/timestack.css).

###Using Timestack with Twix

One option not included above is the `renderDates` option that allows
you to override the way Timestack renders time ranges at a lower level.
The default implementation handles all the stuff about checking whether
we're looking at days or years and formatting accordingly, so you're a
bit on your own if you override it. But one great use case for this is using a third-party library to format
the time ranges. For example, here's how to use Timestack with [Twix](https://github.com/icambron/twix.js):

{% highlight javascript %}
$('#twix').timestack({
  span: 'hour',

  renderDates: function(item){
    return moment.twix(item.start, item.end).format({showDate: false})
  }
});
{% endhighlight %}

<script>
$(function(){
  $('#twix').timestack({
    span: 'hour',
  
    renderDates: function(item){
      return moment.twix(item.start, item.end).format({showDate: false})
    }
  });
});
</script>

<div id='twix'> 
  <ul>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T17:00' data-color='#ADC3DC'>Bob OOO</li>
    <li data-start='2012-08-26T09:00' data-end='2012-08-26T10:30' data-color='#F2C1D3'>Meeting</li>
    <li data-start='2012-08-26T12:00' data-end='2012-08-26T13:00' data-color='#99FF66'>Lunch</li>
    <li data-start='2012-08-26T13:00' data-end='2012-08-26T14:30' data-color='#F2C1D3'>Code review</li>
  </ul>
</div>

Notice the more subtle formatting. You can see a full example of this [here](https://github.com/icambron/timestack/blob/master/examples/twix.html).

##Known Issues

Timestack isn't very defensive with its inputs and it's a little too
easy to break the page by not specifying things correctly. I'm working
on that.

##Credits

Much of the inspiration and CSS comes from Matt Bango's [Pure CSS
Timeline](http://mattbango.com/notebook/web-development/pure-css-timeline/). This would have taken a lot longer and looked a lot worse without his work. There's also Tim Wood's excellent [Moment](http://momentjs.com/) library, which made this a lot easier to build. I'd also like to thank Bota Box Wine, because I drank like eight glasses of it while I wrote this.
