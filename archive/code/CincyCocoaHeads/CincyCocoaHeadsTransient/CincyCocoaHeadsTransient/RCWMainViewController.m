//
//  RCWMainViewController.m
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWMainViewController.h"
#import "RCWAppDelegate.h"
#import "SecretMessage.h"

@interface RCWMainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *publicTF;
@property (weak, nonatomic) IBOutlet UITextField *privateTF;
@property (weak, nonatomic) IBOutlet UITextField *encryptedString;
@property (strong, nonatomic) SecretMessage *msg;
@end

@implementation RCWMainViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    RCWAppDelegate *_del = [UIApplication sharedApplication].delegate;
    
    self.msg = [NSEntityDescription insertNewObjectForEntityForName:@"SecretMessage" inManagedObjectContext:_del.managedObjectContext];
}

- (IBAction)encryptTapped:(UIButton *)sender {
    self.privateTF.text = self.msg.message;
    char *buf = (char *)[self.msg.messageEncrypted bytes];
    NSMutableString *hexed = [[NSMutableString alloc] initWithCapacity:[self.msg.messageEncrypted length]];
    while (*buf) { [hexed appendFormat:@"%0X",(*buf)++]; }
    self.encryptedString.text = hexed;
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(RCWFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    self.msg.message = textField.text;
    [textField resignFirstResponder];
    return YES;
}

@end
