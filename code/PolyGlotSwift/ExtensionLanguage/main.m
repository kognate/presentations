//
//  main.m
//  ExtensionLanguage
//
//  Created by Josh Smith on 3/27/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import <math.h>

static int l_important (lua_State *L) {
    // the arg must be a number
    double d = luaL_checknumber(L, 1);
    lua_pushnumber(L, sin(d) * cos(d) * cos(d));
    return 1;  // we only have one result
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        lua_State *L = luaL_newstate();
        luaL_openlibs(L);
        
        // Expose the function to Lua state
        lua_pushcfunction(L, l_important);
        lua_setglobal(L, "important");
        
        // note the path!!!
        luaL_dofile(L, "/tmp/extension.lua");
        lua_getglobal(L, "configValue");
        lua_Number configValue = lua_tonumber(L, -1);
        printf("Got a number %f\n",configValue);
        return 0;
    }
    return 0;
}
