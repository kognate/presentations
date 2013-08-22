//
//  RCWFlipsideViewController.h
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCWFlipsideViewController;

@protocol RCWFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(RCWFlipsideViewController *)controller;
@end

@interface RCWFlipsideViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <RCWFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
