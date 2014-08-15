{Cc, Cu, Ci} = require("chrome")
Cu.import("resource://gre/modules/devtools/Console.jsm")
Cu.import('resource://gre/modules/FileUtils.jsm')
netUtils = Cu.import("resource://gre/modules/NetUtil.jsm")
zipReader = Cc["@mozilla.org/libjar/zip-reader;1"]
              .createInstance(Ci.nsIZipReader)

class CrxReader
  ###
  @netUtils = Cu.import("resource://gre/modules/NetUtil.jsm");
  @zipReader = Cc["@mozilla.org/libjar/zip-reader;1"]
                .createInstance(Ci.nsIZipReader);

  @fileUtils = Cu.import('resource://gre/modules/FileUtils.jsm').FileUtils;
  ###
  constructor: () ->

  open: (@fileName) =>
    console.debug("CrxReader.open(" + @fileName + ")")
    console.log(Object.prototype.toString.call(zipReader)
      + "in text-crxreader.open")

    crxFile = new FileUtils.File(@fileName)
    try
      zipReader.open(crxFile)
    catch error
      #throw error
      zipReader.close



  getManifest: () =>
    console.log(Object.prototype.toString.call(zipReader)
      + "in crx_reader.getManifest")
    #console.debug(@zipReader)
    #console.debug(Object.getOwnPropertyNames(@zipReader))
    entries = zipReader.findEntries('*')
    console.debug("we have more entries?:" + entries.hasMore())
    while entries.hasMore()
      entryPointer = entries.getNext()
      entry = zipReader.getEntry(entryPointer)
      console.log('entryPointer', entryPointer)

    if zipReader.hasEntry('manifest.json')
      input = zipReader.getInputStream('manifest.json')
      JSON.parse(netUtils.readInputStreamToString(input,
        input.available(), {}))
    else
      null

  close: () =>
    zipReader.close()

module.exports = CrxReader
