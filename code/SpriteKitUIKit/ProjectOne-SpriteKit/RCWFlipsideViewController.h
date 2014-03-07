//
//  RCWFlipsideViewController.h
//  ProjectOne-SpriteKit
//
//  Created by Josh Smith on 3/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCWFlipsideViewController;

@protocol RCWFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(RCWFlipsideViewController *)controller;
@end

@interface RCWFlipsideViewController : UIViewController

@property (weak, nonatomic) id <RCWFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
