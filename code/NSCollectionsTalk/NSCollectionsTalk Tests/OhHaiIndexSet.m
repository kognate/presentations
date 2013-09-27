//
//  OhHaiIndexSet.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface OhHaiIndexSet : XCTestCase

@end

@implementation OhHaiIndexSet

- (void)testIndex
{
    NSIndexSet *idxset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(5, 10)];
    XCTAssertTrue([idxset containsIndex:8], @"Has an 8");
    XCTAssertFalse([idxset containsIndex:1], @"Go Fish");
    
    XCTAssertTrue([idxset indexGreaterThanIndex:5] == 6, @"interesting");
    XCTAssertTrue([idxset indexGreaterThanOrEqualToIndex:5] == 5, @"oh my");
}

- (void) testUsingArrayForThis
{
    NSArray *idxset = @[ @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15];
    XCTAssertTrue([idxset containsObject:@8], @"has an 8");
    XCTAssertFalse([idxset containsObject:@1], @"Go Fish");
    
    NSNumber *found = nil;
    for (NSNumber *n in idxset) {
        if (found != nil) {
            break;
        } else {
            NSPredicate *_p = [NSPredicate predicateWithFormat:@"self > 5"];
            if ([_p evaluateWithObject:n]) {
                found = n;
            }
        }
    }
    
    XCTAssertTrue([found intValue] == 6, @"interesting");
    // Not even doing this one
    // XCTAssertTrue([idxset indexGreaterThanOrEqualToIndex:5] == 5, @"oh my");
}

@end
