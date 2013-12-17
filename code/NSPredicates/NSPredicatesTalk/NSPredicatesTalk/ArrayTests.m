//
//  ArrayTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 11/15/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ArrayTests : XCTestCase

@end

@implementation ArrayTests

- (void)testFilter
{
    NSArray *toFilter = @[ @1, @2, @3, @4, @5, @6 ];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self > 4"];
    NSArray *result = [toFilter filteredArrayUsingPredicate:filter];

    XCTAssert([result count] == 2, @"I'm filtered");
    XCTAssert([result[0] intValue] == 5, @"I'm five");
}

- (void) testMutableFilter
{
    NSMutableArray *filterInPlace = [@[ @1, @2, @3, @4, @5, @6 ] mutableCopy];
    XCTAssert([filterInPlace count] == 6, @"I have six");
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self > 4"];
    
    [filterInPlace filterUsingPredicate:filter];
    
    XCTAssert([filterInPlace count] == 2, @"I have two");
    XCTAssert([filterInPlace[0] intValue] == 5, @"I'm five");
}


- (void) testAny
{
    NSArray *toCheck = @[ @1, @2, @3, @4, @5, @6 ];
    NSPredicate *check = [NSPredicate predicateWithFormat:@"ANY self > 5"];
    XCTAssert([check evaluateWithObject:toCheck], @"I have some values over 5");
    
    // this works for sets, too
    NSSet *toCheckSet = [NSSet setWithObjects:@1, @2, @3, @4, @5, @6, nil];
    XCTAssert([check evaluateWithObject:toCheckSet], @"I have some values over 5");
    
    // even NSCountedSets
    NSCountedSet *toCheckCounted = [NSCountedSet setWithObjects:@1, @2, @3, @4, @5, @6, nil];
    XCTAssert([check evaluateWithObject:toCheckCounted], @"I have some values over 5");
}

- (void) testAll
{
    NSArray *toCheck = @[ @1, @2, @3, @4, @5, @6 ];
    NSPredicate *check = [NSPredicate predicateWithFormat:@"ALL self > 5"];
    XCTAssertFalse([check evaluateWithObject:toCheck], @"Not all of my values are over 5");
    
    NSPredicate *nextCheck = [NSPredicate predicateWithFormat:@"ALL self < 10"];
    XCTAssert([nextCheck evaluateWithObject:toCheck], @"All of my values are less than 10");
    
}

- (void) testNone
{
    NSArray *toCheck = @[ @1, @2, @3, @4, @5, @6 ];
    NSPredicate *check = [NSPredicate predicateWithFormat:@"NONE self > 10"];
    XCTAssert([check evaluateWithObject:toCheck], @"None of my values are greater than 10");
}

- (void) testLength
{
    NSArray *toCheck = @[ @1, @2, @3, @4, @5, @6 ];
    NSPredicate *check = [NSPredicate predicateWithFormat:@"self[SIZE] == 6"];
    XCTAssert([check evaluateWithObject:toCheck], @"I'm good");
    
    XCTAssertThrows([check evaluateWithObject:@"hello!"], @"No length for strings");
    NSPredicate *nextCheck = [NSPredicate predicateWithFormat:@"self.length == 6"];
    XCTAssert([nextCheck evaluateWithObject:@"hello!"], @"I'm good");

}

@end
