//
//  KeyPaths.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "KeyPaths.h"

@implementation KeyPaths 

- (NSArray *) keypaths {

    NSDictionary *_one = @{ @"Firstname" : @"Sam",  @"Birthday" : [NSDate date]  };
    NSDictionary *_two = @{ @"Firstname" : @"Alice",  @"Birthday" : [NSDate date]  };
    NSDictionary *_three = @{ @"Firstname" : @"Amy",  @"Birthday" : [NSNull null] };

    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"Birthday != nil && Firstname != nil"];
    NSArray *_res = [@[ _one, _two, _three] filteredArrayUsingPredicate:_pred];
    return _res;
}

- (NSArray *) nesting {
    NSDictionary *_one = @{ @"Firstname" : @"Sam",  @"Birthday" : @{ @"Date" : [NSDate date]  }};
    NSDictionary *_two = @{ @"Firstname" : @"Alice",  @"Birthday" : @{ @"Date" : [NSDate date]  }};
    NSDictionary *_three = @{ @"Firstname" : @"Amy",  @"Birthday" : @{ @"Date" : [NSNull null] }};
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"Birthday.Date != nil && Firstname != nil"];
    NSArray *_res = [@[ _one, _two, _three] filteredArrayUsingPredicate:_pred];
    return _res;
}

- (NSArray *) toodeep {

    NSDictionary *_one = @{ @"Firstname" : @"Sam",  @"Birthday" : @{ @"Date" : @{ @"real" :[NSDate date]  }}};
    NSDictionary *_two = @{ @"Firstname" : @"Alice",  @"Birthday" : @{ @"Date" : @{ @"real" :[NSDate date]  }}};
    NSDictionary *_three = @{ @"Firstname" : @"Amy",  @"Birthday" : @{ @"Date" : [NSNull null] }};
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"Birthday.Date.real < %@ && Firstname != nil"];
    NSArray *_res = [@[ _one, _two, _three] filteredArrayUsingPredicate:_pred];
    return _res;
}

- (BOOL) blockPredicate {
    NSPredicate *_pred = [NSPredicate predicateWithBlock:^BOOL(NSArray *obj, NSDictionary *bindings)
                          {
                              BOOL _lengthGood = [obj count];
                              NSUInteger idx = [obj indexOfObject:@20];
                              return _lengthGood && idx;
                          }];
    return [_pred evaluateWithObject:@[@1, @20]];
}
@end
