Template.mininav.checkActive = (name) ->
  if Session.get("mininav") == name
    return "active"
  ""

Template.mininav.events =
  'click #stats': () ->
    Session.set("mininav","stats")
  'click #events': () ->
    Session.set("mininav","events")
  'click #categories': () ->
    Session.set("mininav","categories")
