
Template.event_edit.selected = () ->
  return this._id

Template.event_edit.date = () ->
  formatDate(this.date)

Template.event_edit.hours = () ->
  this.seconds.toTimeValue().hours

Template.event_edit.minutes = () ->
  this.seconds.toTimeValue().minutes
  
Template.event_edit.seconds = () ->
  this.seconds.toTimeValue().seconds

Template.event_edit.events =
  'click #save': () ->
    id = this._id
    #TIME
    hours = $("#hours-"+ id).val() * 3600
    minutes = $("#minutes-" + id).val() * 60
    seconds = $("#seconds-" + id).val() * 1
    total = hours + minutes + seconds

    #DATE
    date = $("#date-" + id).val()
    console.log(date)

    #Update everything
    Events.update(this._id,{$set: {seconds: total}})

    
    
  'click #destroy' : () ->
    unless Session.get("eventId") == this._id
      Events.remove({_id: this._id})
    