class Event
  constructor: (@eventTarget, @eventName) ->

  addListener: (callback) =>
    @eventTarget.on(@eventName, callback) is not null

  removeListener: (callback) =>
    @eventTarget.off(@eventName, callback) is not null

  hasListeners: (callback) =>
    @eventTarget.count(@eventName) > 0

exports = Event
