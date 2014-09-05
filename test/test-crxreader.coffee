CrxReader = require("./crx_reader")
Cu.import('resource://gre/modules/osfile.jsm')

Cu.import("resource://gre/modules/devtools/Console.jsm")

exports["test load"] = (assert) =>
  mycrx_reader = new CrxReader(netUtils, zipReader)
  console.log(Object.prototype.toString.call(zipReader) + "in text-crxreader")
  mycrx_zip.
  mycrx_reader.open(OS.Path.join(OS.Constants.Path.profileDir,
    'extensions','adapter',"good.crx"))
  result = mycrx_reader.getManifest()
  assert.notEqual(result, null, "the manifest is null")


require("sdk/test").run(exports)
