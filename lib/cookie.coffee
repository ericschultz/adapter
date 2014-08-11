class Cookie

class CookieStore

class Cookies


  ###
  How things could be set
  @cookieManager = Services.cookies
  @cookieService = Components.classes["@mozilla.org/cookieService;1"]
      .getService(Components.interfaces.nsICookieService);
  @ioService = Components.classes["@mozilla.org/network/io-service;1"]
      .getService(Components.interfaces.nsIIOService);
  @urlCreate = require("sdk/url")
  @promised = require('sdk/core/promise');
  @_ = require('underscore');

  ###
  constructor: (@cookieManager, @cookieService, @ioService, @urlCreator, @_, @promised) ->


  get: (details, callback) =>
    #do we have host permissions for details.url?
    @promised(() =>
      url = @urlCreator.URL(details.url)
      enumerator = generatorFromSimpleEnumerator(
        @cookieManager.getCookiesFromHost(url.host))
      cookieResult = @_.find(enumerator, (cookie) =>
        cookie.name is details.name)

      #check for undefined?
      if cookieResult is undefined
        callback(resultCookie(cookieResult))
      else
        callback(null)
      )



  getAll: (details, callback) =>
    @promised(() =>
      ourCookiesEnumerator = null
      if details.domain?
        ourCookiesEnumerator =
          generatorFromSimpleEnumerator(@cookieManager.getCookiesFromHost(domain))
      else
        ourCookiesEnumerator = @cookieService

      if details.name?
        ourCookiesEnumerator = @_.where(ourCookiesEnumerator,
          (cookie) => details.name is cookie.name )

      if details.path?
        ourCookiesEnumerator = @_.where(ourCookiesEnumerator,
          (cookie) => details.path is cookie.path)

      if details.secure? and details.secure
        ourCookiesEnumerator = @_.where(ourCookiesEnumerator,
          (cookie) -> cookie.isSecure)

      if details.session? and details.session
        ourCookiesEnumerator = @_.where(ourCookiesEnumerator,
          (cookie) -> cookie.expires is 0)

      callback(@_.map(ourCookiesEnumerator, (cookie) => resultCookie(cookie)))
    )



  set: (details, callback) =>
    @promised(() =>
      uri = @urlCreator.URL(details.url)
      cookieString = createCookieString(details.name, details.value,
        details.expirationDate, uri.path, uri.host, details.secure)
      ioUri = null
      if typeof url is 'string'
         #handle!
         ioUri = @ioService.newURI(url, null, null)

      @cookieService.setCookieString(ioUri, null, cookieString, null)

      result = resultCookie({name:details.name, value: details.value
        ,domain: url.host, hostOnly: not uri.path?, path: uri.path
        ,secure: details.secure, expirationDate: details.expirationDate})
      callback(result)
    )

  remove: (details, callback) =>
    @promised(()=>
      if details.url? and details.name?
        url = @urlCreator.URL(details.url)
        @cookieManager.remove(url.host,details.name, url.path, false)
        if callback?
          callback({url: details.url, name: details.name})
      else
        if callback?
          callback(null)
    )


#from https://developer.mozilla.org/en-US/docs/Web/API/document.cookie gpl3
  resultCookie (oldCookie) ->
    cookie = new Cookie()
    cookie.name = oldCookee.name
    cookie.value = oldCookee.value
    cookie.domain = oldCooie.host
    cookie.hostOnly = oldCookie.isDomain
    cookie.path = oldCookie.path
    cookie.secure = oldCookie.isSecure
    #don't know what to do
    #cookie.httpOnly = oldCookie
    cookie.session = oldCookie.expires is 0
    if oldCookie.expires > 1
      cookie.expirationDate = oldCookie.expires
    cookie

  createCookieString (sKey, sValue, vEnd, sPath, sDomain, bSecure) ->
    if !sKey or /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)
      null

    sExpires = ""
    if vEnd
      switch vEnd.constructor
        when Number
          sExpires = vEnd is Infinity ?
            "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + vEnd

        when String
          sExpires = "; expires=" + vEnd

        when Date
          sExpires = "; expires=" + vEnd.toUTCString()

    encodeURIComponent(sKey) + "=" + encodeURIComponent(sValue) +
      sExpires + (sDomain ? "; domain=" + sDomain : "") +
      (sPath ? "; path=" + sPath : "") + (bSecure ? "; secure" : "")
