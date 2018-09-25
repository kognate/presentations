//
//  NotTerrible.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "NotTerrible.h"

@implementation NotTerrible

- (BOOL) predicatesTIT:(NSString *)_myarg {
    NSPredicate *beginsWithCH = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *longEnough = [NSPredicate predicateWithFormat:@"SELF.length > 3"];
    NSPredicate *shortEnough = [NSPredicate predicateWithFormat:@"SELF.length < 20"];
    NSPredicate *containsDigit = [NSPredicate predicateWithFormat:@"SELF matches '.*\\\\d.*'"];
    NSPredicate *containsSpace = [NSPredicate predicateWithFormat:@"SELF contains ' '"];
    NSPredicate *containsBroken = [NSPredicate predicateWithFormat:@"SELF contains 'broken'"];
    NSPredicate *notContainsBroken = [NSCompoundPredicate notPredicateWithSubpredicate:containsBroken];
    NSPredicate *notContainsSpace = [NSCompoundPredicate notPredicateWithSubpredicate:containsSpace];
    
    NSArray *_preds = @[ beginsWithCH, longEnough, shortEnough, notContainsBroken,
        notContainsSpace, containsDigit];
    
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}

- (BOOL) predicatesTITshort:(NSString *)_myarg {
    
    NSPredicate *one = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *two = [NSPredicate predicateWithFormat:@"SELF.length > 3 AND self.length < 20"];
    
    NSString *lps = @"SELF matches '.*\\\\d.*' and NOT(SELF contains ' ') and NOT(SELF contains 'broken')";
    NSPredicate *three = [NSPredicate predicateWithFormat:lps];
    
    NSArray *_preds = @[ one, two, three ];
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}
@end
