//
//  ViewController.swift
//  PolyGlotSwift
//
//  Created by Josh Smith on 3/26/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

import UIKit
import JavaScriptCore

struct LuaResult {
    let code: Int32
    let results: [String]
}

class LuaObject {
     let L: COpaquePointer
    
    init() {
        L = luaL_newstate()
        luaL_openlibs(L)
    }
    
    deinit {
        lua_close(L)
    }
    
    func eval(script: String) -> LuaResult {
    
        lua_settop(L, 0)
    
        let load_error = luaL_loadstring(L, script)
        if load_error == LUA_OK {
            
            let pcall_error = lua_pcallk(L, 0, LUA_MULTRET, 0, 0, nil)
            if (pcall_error == LUA_OK) {
                
                let results_count = lua_gettop(L)
                var result_messages : [String] = [];
                for var i = results_count; i > 0; i-- {
                    if let msg =  String(UTF8String: lua_tolstring(L, -1 * i, nil)) {
                        result_messages.append(msg)
                    }
                }
                
                return LuaResult(code: LUA_OK, results: result_messages)
                
            } else {
                if let msg = String(UTF8String: lua_tolstring(L, -1, nil)) {
                    return LuaResult(code: load_error, results: [msg]);
                } else {
                    return LuaResult(code: load_error, results: []);
                }
            }
        } else {

            if let msg = String(UTF8String: lua_tolstring(L, -1, nil)) {
                return LuaResult(code: load_error, results: [msg]);
            } else {
                return LuaResult(code: load_error, results: []);
            }
    
        }
    
    }
    
    func execute_function_in_file(filename: String) -> Int32 {
        lua_settop(L, 0)
        let loadfile_error = luaL_loadfilex(L, filename, nil)
        if (loadfile_error == LUA_OK) {
            lua_pcallk(L, 0, 0, 0, 0, nil)
            lua_getglobal(L, "result")
            let res: CDouble = lua_tonumberx(L, -1, nil)
            return Int32(res)
        } else {
            return -1
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var squareInput: UITextField!
    @IBOutlet weak var squareOutput: UILabel!
    @IBAction func squareNumber(sender: AnyObject) {
        let context = JSContext()
        let filePath = NSBundle.mainBundle().pathForResource("javascript", ofType: "js")
        let scriptFile = String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
        context.evaluateScript(scriptFile)
        let square = context.objectForKeyedSubscript("square")
        if let toSquare = squareInput.text.toInt() {
            let result = square.callWithArguments([toSquare]).toInt32()
            squareOutput.text = String(result)
        }
    }

    @IBOutlet weak var luaInput: UITextField!
    @IBOutlet weak var luaOutput: UILabel!
    @IBAction func evalLua(sender: AnyObject) {
        let luaobj = LuaObject()
        let result = luaobj.eval(luaInput.text)
        luaOutput.text = ", ".join(result.results)
    }
    
    
    @IBAction func evalFile(sender: AnyObject) {
        let luaobj = LuaObject()
        let filePath = NSBundle.mainBundle().pathForResource("bizlogic", ofType: "lua")
        let v = luaobj.execute_function_in_file(filePath!)
        print(v)
    }
}

