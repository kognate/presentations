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
    
   }

- (IBAction)stop:(id)sender {
    [self.motion stopAccelerometerUpdates];
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
    
    // Open with threading support
    
    int options = SQLITE_OPEN_FULLMUTEX| SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE;
    
    int result = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSASCIIStringEncoding], &_db, options, NULL);
    
    NSAssert(result == SQLITE_OK,@"open completed correctly");
    
    result = sqlite3_exec(_db, "create table gyro ( updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, x double, y double, z double)", NULL, NULL, NULL);
    NSAssert(result == SQLITE_OK,@"exec completed correctly");
    
    [self.motion startAccelerometerUpdatesToQueue:self.queue
                                      withHandler:^(CMAccelerometerData *adata, NSError *error) {
                                          if (_db != NULL) {
                                              sqlite3_stmt *stmt;
                                              sqlite3_exec(_db, "BEGIN", NULL, NULL, NULL);
                                              const char *insert = "insert into gyro (x,y,z) values (:x,:y,:z)";
                                              sqlite3_prepare_v2(_db, insert, (int)strlen(insert), &stmt, NULL);
                                              int xParamIndex = sqlite3_bind_parameter_index(stmt, ":x");
                                              sqlite3_bind_double(stmt, xParamIndex, adata.acceleration.x);
                                              
                                              int yParamIndex = sqlite3_bind_parameter_index(stmt, ":y");
                                              sqlite3_bind_double(stmt, yParamIndex, adata.acceleration.y);
                                              
                                              int zParamIndex = sqlite3_bind_parameter_index(stmt, ":z");
                                              sqlite3_bind_double(stmt, zParamIndex, adata.acceleration.z);

                                              if (sqlite3_step(stmt) == SQLITE_DONE) {
                                                  sqlite3_exec(_db, "COMMIT", NULL, NULL, NULL);
                                              } else {
                                                  sqlite3_exec(_db, "ROLLBACK", NULL, NULL, NULL);
                                              }
                                              
                                              sqlite3_finalize(stmt);
                                          }

                                      }];
    
}

@end
