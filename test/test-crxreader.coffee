CrxReader = require("./crx_reader")
{Cc, Cu, Ci} = require("chrome")
netUtils = Cu.import("resource://gre/modules/NetUtil.jsm")
zipReader = Cc["@mozilla.org/libjar/zip-reader;1"]
              .createInstance(Ci.nsIZipReader)
Cu.import('resource://gre/modules/osfile.jsm')
fileUtils = Cu.import('resource://gre/modules/FileUtils.jsm').FileUtils
Cu.import("resource://gre/modules/devtools/Console.jsm")

exports["test load"] = (assert) =>
  mycrx_reader = new CrxReader(netUtils, zipReader)
  console.log(Object.prototype.toString.call(zipReader) + "in text-crxreader")
  mycrx_reader.open(OS.Path.join(OS.Constants.Path.profileDir,
    'extensions','adapter',"good.crx"))
  result = mycrx_reader.getManifest()
  assert.notEqual(result, null, "the manifest is null")


require("sdk/test").run(exports)
