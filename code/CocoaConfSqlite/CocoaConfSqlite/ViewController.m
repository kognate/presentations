//
//  ViewController.m
//  CocoaConfSqlite
//
//  Created by Josh Smith on 3/25/15.
//  Copyright (c) 2015 Josh Smith. All rights reserved.
//

#import "ViewController.h"
#import "ShowDataTableViewController.h"
#import <sqlite3.h>

@import CoreMotion;

@interface ViewController ()
@property (strong, nonatomic) CMMotionManager *motion;
@property (strong,nonatomic) NSOperationQueue *queue;
@property (assign) sqlite3 *db;
@property (copy) NSString *dbPath;
@end

@implementation ViewController

- (void) viewDidLoad {
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    
    sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    
    
    self.motion = [[CMMotionManager alloc] init];
    self.motion.accelerometerUpdateInterval = 1;
    self.motion.magnetometerUpdateInterval = 1;
   }

- (IBAction)stop:(id)sender {
    [self.motion stopMagnetometerUpdates];
    sqlite3_close(_db);
    _db = NULL;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowDataTableViewController *sdtvc = segue.destinationViewController;
    sdtvc.dbPath = self.dbPath;
}

- (IBAction)start:(id)sender {

    self.dbPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"motion.sqlite"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.dbPath]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:self.dbPath error:&error];
    }
    
    // OPEN
    
    int result = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSASCIIStringEncoding], &_db, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE, NULL);
    NSAssert(result == SQLITE_OK,@"open completed correctly");
    
    result = sqlite3_exec(_db, "create table magfield ( updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, x double, y double, z double)", NULL, NULL, NULL);
    NSAssert(result == SQLITE_OK,@"exec completed correctly");
    
    [self.motion startMagnetometerUpdatesToQueue:self.queue
                                     withHandler:^(CMMagnetometerData *mdata, NSError *error) {
                                         if (_db != NULL) {
                                             sqlite3_stmt *stmt;
                                             const char *insert = "insert into magfield (x,y,z) values (?,?,?)";
                                             sqlite3_prepare_v2(_db, insert, (int)strlen(insert), &stmt, NULL);
                                             sqlite3_bind_double(stmt, 0, mdata.magneticField.x);
                                             sqlite3_bind_double(stmt, 1, mdata.magneticField.y);
                                             sqlite3_bind_double(stmt, 2, mdata.magneticField.z);
                                             sqlite3_step(stmt);
                                             sqlite3_finalize(stmt);
                                         }
                                     }];
}

@end
