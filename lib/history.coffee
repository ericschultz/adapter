

class History

  ###
  @history = require('sdk/places/history')
  @nsINavHistoryService = Components
     .classes["@mozilla.org/browser/nav-history-service;1"]
     .getService(Components.interfaces.nsINavHistoryService);
  //used for removal
  @nsIBrowserHistory = Components
    .classes["@mozilla.org/browser/nav-history-service;1"]
    .getService(Components.interfaces.nsIBrowserHistory);
  @asyncHistory = Components
    .classes["@mozilla.org/browser/history;1"]
    .getService(Components.interfaces.mozIAsyncHistory);
  @promised = require('sdk/core/promise');
  @ioService = Components.classes["@mozilla.org/network/io-service;1"]
                    .getService(Components.interfaces.nsIIOService);
  ###
  constructor: (@history, @nsINavHistoryService, @nsIBrowserHistory,
    @asyncHistory, @promised, @event, @ioService) ->




  addUrl: (details, callback) =>
    @asyncHistory.getPlacesInfo(details.url, ())


  search: (query, callback) =>

  deleteUrl: (details, callback) =>

      promised(() =>
        if details.url?
          @nsIBrowserHistory.remove(@ioService.newURI(details.url)))
          if callback?
            callback()

      )
  deleteRange: (range, callback) =>
    @promised(() =>
      @nsIBrowserHistory.removeRange(range.startTime, range.EndTime)
      callback()
      )


  deleteAll: (callback) =>
    @promised(() =>
      @nsIBrowserHistory.removeAllPages()
      callback())
