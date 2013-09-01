pomoSec = 0
transition = false
alarm = new Audio("alarmclock.wav")
resume = "normal"

playAlarm = () ->
  alarm.play()

stopAlarm = () ->
  alarm.pause()
  alarm.currentTime = 0

Template.timer.status = () ->
  Session.get("timer")

Template.timer.transition = () ->
  transition

Template.timer.checkButton = (name) ->
  if Session.get("timer") == name
    return true
  false  

Template.timer.activated = () ->
  Session.get("eventId") != null

Template.timer.event_name = () ->
  e = Events.findOne(Session.get("eventId"))
  e.name

Template.timer.event_date = () ->
  e = Events.findOne(Session.get("eventId"))
  formatDate(e.date)

Template.timer.timer = () ->
  if Session.get("eventId") != null
    e = Events.findOne(Session.get("eventId"))
    if Session.get("timer") != "pomo"
      result = e.seconds.toString().toTime()
      return result
    else
      result = (pomoSec).toString().toTime()
      return result
   "NO EVENT SELECTED"

id = null

pomoInterval = () ->
  start = new Date()
  e = Events.findOne({_id: Session.get("eventId")})
  original = e.seconds
  id = Meteor.setInterval(() ->
    console.log("pomo")
    now = new Date()
    additional = (now.getTime() - start.getTime()) / 1000
    total = original + additional 
    e = Events.update(Session.get("eventId"), {$set: {pomo: total}})
    pomoSec = total
    pomoTimer()
  , 1000)

activityInterval = () ->
  start = new Date()
  e = Events.findOne({_id: Session.get("eventId")})
  original = e.seconds
  id = Meteor.setInterval(() ->
    console.log("active")
    now = new Date()
    additional = (now.getTime() - start.getTime()) / 1000
    total = original + additional
    e = Events.update(Session.get("eventId"), {$set: {seconds: total}})
    activityTimer()
  , 1000)

activeMode = () ->
  stopAlarm()
  transition = false
  Session.set("timer","stop")
  Meteor.clearInterval(id)
  activityInterval()

pomoMode = () ->
  stopAlarm()
  transition = false
  Meteor.clearInterval(id)
  Session.set("timer","pomo")
  pomoInterval()

activityTimer = () ->
  u = getUserProfile()
  return if u.mode == "Normal"
  e = Events.findOne({_id: Session.get("eventId")})
  if (e.seconds % (u.activitylength * 60)) == 0
    transition = true
    playAlarm()
    
pomoTimer = () ->
  u = getUserProfile()
  e = Events.findOne({_id: Session.get("eventId")})
  if (pomoSec % (u.pomotime * 60)) == 0
    transition = true
    playAlarm()

Template.timer.events =
  'click #start' : () ->
    if Session.get("eventId") == null && Meteor.user()
      e = Events.insert({user_id: Meteor.userId(), seconds: 0, pomo: 0, date: new Date(), name: null})
      Session.set("eventId",e)
      Session.set("timer", "stop")
      activityInterval()

  'click #resume' : () ->
    if resume == "normal"
      Session.set("timer","stop")
      activityInterval()
    else
      Session.set("timer", "pomo")
      pomoInterval()  
      
  'click #rest' : () ->
    pomoMode()

  'click #work' : () ->
    activeMode()
    
  'click #skip' : () ->
    activeMode()
        
  'click #stop' : () ->
    if (Session.get("timer") == "pomo")
      resume = "pomo"
    else
      resume = "normal"  
    Session.set("timer", "resume") 
    Meteor.clearInterval(id)
    
  'click #finish' : () ->
    stopAlarm()
    pomoSec = 0
    transition = false
    Session.set("timer","start")
    Session.set("eventId",null)
    Meteor.clearInterval(id)

