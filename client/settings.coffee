
getUserProfile = () ->
  u = Meteor.user()
  if u.profile.mode == undefined
    Meteor.users.update({_id: u._id }, {$set: {"profile.mode": "Normal", "profile.pomotime": 10}})
  u.profile

Template.settings.mode = () ->
  u = getUserProfile()
  u.mode

Template.settings.events =
  'click #mode' : () ->
    id = "#mode"
    $(id).replaceWith("<dd id='modeForm'><select id='modeSelect'><option>Normal</option><option>Pomodoro</option></select><input type='button' value='submit' id='modeSubmit'/></dd>")

   'click #modeSubmit' : () ->
     choice = $("#modeSelect").val()
     u = getUserProfile()
     Meteor.users.update({_id: Meteor.userId()}, {$set: {"profile.mode": choice}})
     $("#modeForm").replaceWith("<dd id='mode'>#{u.mode}</dd>")