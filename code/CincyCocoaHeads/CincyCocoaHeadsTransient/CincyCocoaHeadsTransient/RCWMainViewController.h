//
//  RCWMainViewController.h
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWFlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface RCWMainViewController : UIViewController <RCWFlipsideViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
