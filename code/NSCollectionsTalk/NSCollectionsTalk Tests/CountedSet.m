//
//  CountedSet.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CountedSet : XCTestCase

@end

@implementation CountedSet

- (void)testCounted
{
    NSCountedSet *cs = [[NSCountedSet alloc] initWithArray:@[ @3, @4, @4, @4, @5, @1, @5]];
    XCTAssertTrue([cs count] == 4, @"only have four elements");
    
    XCTAssertTrue([cs countForObject:@3] == 1, @"only 1 3");
    XCTAssertTrue([cs countForObject:@4] == 3, @"3 4s");
    XCTAssertTrue([cs countForObject:@5] == 2, @"2 5s");
    XCTAssertTrue([cs countForObject:@1] == 1, @"only 1 1");
    XCTAssertTrue([cs countForObject:@10] == 0, @"no 10s");
    
    [cs addObject:@1];
    XCTAssertTrue([cs countForObject:@1] == 2, @"Now 2 1s");
}

- (void) testByArray
{
    NSArray *ar = @[ @3, @4, @4, @4, @5, @1, @5];
    XCTAssertTrue([ar count] == 7, @"Has 7 elements");
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self == 3"];
    XCTAssertTrue([[ar filteredArrayUsingPredicate:filter] count] == 1, @"that's cumbersome");
    
    filter = [NSPredicate predicateWithFormat:@"self == 4"];
    XCTAssertTrue([[ar filteredArrayUsingPredicate:filter] count] == 3, @"that's cumbersome");
}

- (void) testReallyCumbersome
{
    NSArray *ar = @[ @3, @4, @4, @4, @5, @1, @5];
    __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [ar enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        NSNumber *cnt = dic[[obj stringValue]];
        if (cnt == nil) {
            dic[[obj stringValue]] = @(1);
        } else {
            dic[[obj stringValue]] = @([cnt intValue] + 1);
        }
    }];
    
    XCTAssertTrue([dic[[@3 stringValue]] intValue] == 1, @"only 1 3");
    XCTAssertTrue([dic[[@4 stringValue]] intValue] == 3, @"3 4s");
    XCTAssertTrue([dic[[@5 stringValue]] intValue] == 2, @"2 5s");
    XCTAssertTrue([dic[[@1 stringValue]] intValue] == 1, @"only 1 1");
    XCTAssertTrue([dic[[@10 stringValue]] intValue] == 0, @"no 10s");
}

@end
