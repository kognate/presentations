//
//  NotReallyTerrible.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "NotReallyTerrible.h"

@implementation NotReallyTerrible

- (BOOL) predicatesTIRT:(NSString *)_myarg {
    NSPredicate *beginsWithCH = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *beginsWithHC = [NSPredicate predicateWithFormat:@"SELF beginswith 'HC'"];
    NSPredicate *longEnough = [NSPredicate predicateWithFormat:@"SELF.length > 3"];
    NSPredicate *shortEnough = [NSPredicate predicateWithFormat:@"SELF.length < 20"];
    NSPredicate *containsDigit = [NSPredicate predicateWithFormat:@"SELF matches '.*\\\\d.*'"];
    NSPredicate *containsSpace = [NSPredicate predicateWithFormat:@"SELF contains ' '"];
    NSPredicate *containsBroken = [NSPredicate predicateWithFormat:@"SELF contains 'broken'"];
    NSPredicate *notCB = [NSCompoundPredicate notPredicateWithSubpredicate:containsBroken];
    NSPredicate *notCS = [NSCompoundPredicate notPredicateWithSubpredicate:containsSpace];
    
    NSArray *_ch = [NSArray arrayWithObjects:beginsWithCH,notCB, nil];
    NSPredicate *chnotbroken = [NSCompoundPredicate andPredicateWithSubpredicates:_ch];
    NSArray *_hc = [NSArray arrayWithObjects:beginsWithHC,containsBroken,nil];
    NSPredicate *hcbroken = [NSCompoundPredicate andPredicateWithSubpredicates:_hc];
    
    NSArray *_chhc = [NSArray arrayWithObjects:chnotbroken,hcbroken, nil];
    NSPredicate *begins = [NSCompoundPredicate orPredicateWithSubpredicates:_chhc];
    
    NSArray *_preds = [NSArray arrayWithObjects:begins,
                       longEnough,
                       shortEnough,
                       containsDigit,
                       notCS,
                       nil];
    
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}
@end
