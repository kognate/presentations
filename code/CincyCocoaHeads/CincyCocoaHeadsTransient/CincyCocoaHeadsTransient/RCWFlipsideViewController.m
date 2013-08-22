//
//  RCWFlipsideViewController.m
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWFlipsideViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface RCWFlipsideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *toHash;
@property (weak, nonatomic) IBOutlet UITextView *hexval;

@end

@implementation RCWFlipsideViewController

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doHash:(id)sender {
    NSData *data = [self.toHash.text dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *hashhex = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hashhex appendFormat:@"%x", digest[i]];
    }
    
    self.hexval.text = hashhex;
}



@end
