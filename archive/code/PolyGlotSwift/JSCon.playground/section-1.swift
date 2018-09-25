// Playground - noun: a place where people can play

import UIKit
import JavaScriptCore

var str = "Hello, playground"

let funcstr = "var isValid = function(boolv) { return boolv; }"
let myContext = JSContext()
myContext.evaluateScript(funcstr)

let myJSV = myContext.objectForKeyedSubscript("isValid")

myJSV.callWithArguments(["true"]).toBool()

let myPath = NSFileManager.defaultManager().currentDirectoryPath

let onDisk = String(contentsOfFile: "javascript.js", encoding: NSUTF8StringEncoding, error: nil)

//myContext.evaluateScript(onDisk)

//let mySquare = myContext.objectForKeyedSubscript("square")

//if let j = "10".toInt() {
//    mySquare.callWithArguments([j]).toInt32()
//}








