//
//  ThisIsReallyTerrible.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "ThisIsReallyTerrible.h"

@implementation ThisIsReallyTerrible

- (BOOL) thisIsReallyTerrible:(NSString *)_myarg {
    BOOL _res = NO;
    if ([_myarg length] > 3) {
        if ([_myarg length] < 20) {
            NSCharacterSet *s = [NSCharacterSet decimalDigitCharacterSet];
            if ([[_myarg componentsSeparatedByCharactersInSet:s] count] > 1) {
                NSCharacterSet *w = [NSCharacterSet whitespaceCharacterSet];
                if ([[_myarg componentsSeparatedByCharactersInSet:w] count] == 1) {
                    if ([[_myarg substringToIndex:2] isEqualToString:@"CH"]) {
                        if ([[_myarg componentsSeparatedByString:@"broken"] count] == 1) {
                            _res = YES;
                        }
                    } else if ([[_myarg substringToIndex:2] isEqualToString:@"HC"]) {
                        if ([[_myarg componentsSeparatedByString:@"broken"] count] > 1) {
                            _res = YES;
                        }
                    }
                }
            }
        }
    }
    return _res;
}
@end
