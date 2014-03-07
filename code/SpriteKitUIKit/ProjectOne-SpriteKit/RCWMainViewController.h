//
//  RCWMainViewController.h
//  ProjectOne-SpriteKit
//
//  Created by Josh Smith on 3/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "RCWFlipsideViewController.h"
@import SpriteKit;

@interface RCWMainViewController : UIViewController <RCWFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end

@interface FireWorksView : SKScene

@end
