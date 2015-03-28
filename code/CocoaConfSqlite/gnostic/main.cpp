//
//  main.cpp
//  gnostic
//
//  Created by Josh Smith on 3/26/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

#include <iostream>
#include <sstream>
#include <string>
#include <strings.h>
#include <sqlite3.h>

void truncateText(sqlite3_context *context, int argc, sqlite3_value **argv) {
    const unsigned char *text = sqlite3_value_text(argv[0]);
    char *truncated = (char *)calloc(sizeof(char), 15);
    strncpy(truncated, (const char *)text, 15);
    sqlite3_result_text(context, truncated, (int)strlen(truncated), SQLITE_TRANSIENT);
    free(truncated);
}

int main(int argc, const char * argv[]) {
    
    if (argc < 3) {
        std::cerr << "gnostic DBFILE WORDS..TO..SEARCH..FOR" << std::endl;
        exit(1);
    }

    sqlite3 *db;
    sqlite3_open(argv[1], &db);
    sqlite3_create_function(db,"truncateField",1,SQLITE_UTF8, NULL, &truncateText, NULL,NULL);

    sqlite3_stmt *stmt;
    
    std::ostringstream commands;
    
    for (int i = 2; i < argc; i++) {
        commands << argv[i] << " ";
    }
    
    std::string commandsStr = commands.str();
    const char *commandsCStr = commandsStr.c_str();
    
    const char *query = "select id,graph from graphs where graphs match :matchwords";
    // const char *query = "select id,truncateField(graph) from graphs where graphs match :matchwords";
    
    sqlite3_prepare(db, query, (int)strlen(query), &stmt, NULL);
    int param_index = sqlite3_bind_parameter_index(stmt, ":matchwords");
    sqlite3_bind_text(stmt, param_index, commandsCStr, (int)strlen(commandsCStr), NULL);
    
    int items_found = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        int colid = sqlite3_column_int(stmt, 0);
        const unsigned char *graph = sqlite3_column_text(stmt, 1);
        std::cout << colid << std::endl;
        std::cout << graph << std::endl << std::endl;
        items_found++;
    }
    
    std::cout << "Found : " << items_found << std::endl;
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return 0;
}
