//
//  ShowDataTableViewController.h
//  CocoaConfSqlite
//
//  Created by Josh Smith on 3/25/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ShowDataTableViewController : UITableViewController
@property (copy) NSString *dbPath;

@end
