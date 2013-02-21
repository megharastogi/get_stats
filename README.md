There are lot of  analytics tools out there which you can integrate with your application and get statistics you need, but they do not always provide full control over the information plus you always have to go back to there site to get the information. 

I built a simple way to study your Rails app's usage analysis from with in your application. It's called GetStats.

[https://github.com/megharastogi/get_stats](https://github.com/megharastogi/get_stats)

If you have any trouble let me know on [Twitter](https://twitter.com/megharastogi) or email.

Installation
------------

- Add `'get_stats', '~> 0.0.1'` to your Gemfile.
- Run `bundle install`.
- Restart your server 
- rails generate get_stats
- rake db:migrate

This will create a stats table in your database to store all the information.

GetStats Usage
----------------

To store any kind of metrix you want to track, all you need to add in your code is:

```
Stats.increment('stats_name')
```
Where 'stats_name' is the name you want to assign to mertix ex: 'sign_ups','successful_payment','account deleted'

Examples
--------- 

If you want to track number of signups everyday, you can add a call to Stats in 'after_create' to log the amount of signups every day.

```
class User < ActiveRecord::Base
   def after_create
      Stats.increment('sign_ups')
   end
end
```
If the 'sign_ups'[stat_name] does not exists it will create one, otherwise it will just add to previously
existing stats.

Or if want to track number of succesfull payment made everyday you can do

```
class Payment < ActiveRecord::Base
   def after_create
      if status == 'Success'
        Stats.increment('successful_payment')
      else
        Stats.increment('failed_payment_attempt')
      end 
   end
end
```

You can also pass the date attribute with 'increment' method to back fill data. For example if want to track how many users signed up on each day, you can add something like this to a rake task:

```
  @users.each do |u|
      Stats.increment('sign_ups', u.created_at)
  end    
```

```
  @payments.each do |p|
      if p.status == 'Success'
        Stats.increment('successful_payment',p.created_at)
      else
        Stats.increment('failed_payment_attempt',p.created_at)
      end
  end    
```
Now that you have stored all the information, to just need to call 

```
  Stats.show(stat_name)
  Stats.show('sign_ups')
  Stats.show('successful_payment')
```
By default it will show you the data collected over last week, but you can also pass options for viewing data for last month, or a particular time range.

```
  Stats.show(stat_name,'week')
  Stats.show(stat_name,'month')
  Stats.show(stat_name,'time_range', start_date, end_date)

```
```
  Stats.show('sign_ups','week')
  Stats.show('sign_ups','month')
  Stats.show('sign_ups','time_range', Date.today - 15.days, Date.today)

```

Data Returned
-------------

Stats.show returns an array of data with count everyday

```
Stats.show('sign_ups','week') 
["sign_ups", Sat, 16 Feb 2013, 0], ["sign_ups", Sun, 17 Feb 2013, 2], ["sign_ups", Mon, 18 Feb 2013, 4], ["sign_ups", Tue, 19 Feb 2013, 5], ["sign_ups", Wed, 20 Feb 2013, 0], ["sign_ups", Thu, 21 Feb 2013, 0]]
```

Displaying Graphs
-----------------
For displaying data returned in to graphs I am using highcharts.js, to add graphs to your views you will have to include add highcharts which is already added in the assets and then use partial 'display_graph'

```
<%= javascript_include_tag :highcharts %>

<% @signups = Stats.show('sign_ups','week') %>
<%= render :partial => "./display_graph", :locals => {:stats => @signups,:graph_type => "line"}%>
```
Different options you can pass to graph_type are
- 'line'
- 'area'
- 'bar'
- 'column'

Feedback
--------
[Source code available on Github](https://github.com/megharastogi/get_stats). Feedback are greatly appreciated.  


