//
//  RCWAppDelegate.h
//  CodeMash
//
//  Created by Josh Smith on 1/9/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RCWAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
