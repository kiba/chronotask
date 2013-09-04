Template.stats.total_hours = () ->
  seconds = 0
  events = Events.find({user_id: Meteor.userId()})
  events.forEach((e) ->
    seconds += e.seconds
  )
  (seconds / 3600).toFixed(2)

Template.stats.last_page = () ->
  return true if Session.get("weeknav") == 0

Template.stats.week_of = () ->
  formatDate(week_of(Session.get("weeknav")))

Template.stats.this_week = () ->
  dates = get_week(Session.get("weeknav"))
  newdates = []
  for d in dates
    newdates.push(date: d.date, total: d.total.toFixed(2))
  newdates  
  
Template.stats.total_for_week = () ->  
  seconds = 0
  dates = get_week(Session.get("weeknav"))
  dates.forEach((d) ->
    seconds += d.total
  )
  seconds.toFixed(2)
    
Template.stats.size = () ->
  Events.find({user_id: Meteor.userId()}).count()

Template.stats.events =
  'click #previous' : () ->
    d = Session.get("weeknav")
    d += 1
    Session.set("weeknav", d)
  'click #next' : () ->
    d = Session.get("weeknav")
    d += -1
    Session.set("weeknav", d)