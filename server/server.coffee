Meteor.publish("events", () ->
  Events.find({or: {user_id: Meteor.user().id}})
)