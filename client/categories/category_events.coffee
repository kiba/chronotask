Template.category_events.list = () ->
  Events.find({name: Session.get("category")},{sort: {seconds: -1}})

Template.category_events.category_name = () ->
  Session.get("category")

Template.category_events.events = 
  "click #return" : () ->
    Session.set("category", false)  