//
//  HeyNSOrderedSet.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HeyNSOrderedSet : XCTestCase

@end

@implementation HeyNSOrderedSet

- (void)testSimple
{
    NSOrderedSet *os = [[NSOrderedSet alloc] initWithArray:@[ @1, @2, @3, @4, @5, @6 ]];
    XCTAssertTrue([os count] == 6, @"Has six elements");
    
    XCTAssertTrue([os containsObject:@5], @"Do you have five?");
    XCTAssertFalse([os containsObject:@0], @"Go Fish");

    XCTAssertTrue([[os objectAtIndexedSubscript:2] isEqualToNumber:@3], @"Woah,  subscript?");
    XCTAssertTrue([[os objectAtIndex:2] isEqualToNumber:@3], @"Seems legit");
    
    XCTAssertThrows([os objectAtIndex:100], @"I throw, just like arrays");
    
    NSSet *subset = [[NSSet alloc] initWithObjects:@0, @1, @2, @3, @4, @5, @6, @7, nil];
    
    XCTAssertTrue([os isSubsetOfSet:subset], @"try that with an array");
    XCTAssertTrue([os intersectsSet:subset], @"yeah, it intersects, too");
    
    NSSet *nonintersects = [[NSSet alloc] initWithObjects:@7, @8, @9, nil];
    
    XCTAssertFalse([os intersectsSet:nonintersects], @"nope, no intersection");
}

- (void) testHowIWouldDoThisWithArrays
{
    NSArray *os = @[ @1, @2, @3, @4, @5, @6 ];
    XCTAssertTrue([os count] == 6, @"Has six elements");
    
    XCTAssertTrue([os containsObject:@5], @"Do you have five?");
    XCTAssertFalse([os containsObject:@0], @"Go Fish");
    
    XCTAssertTrue([[os objectAtIndexedSubscript:2] isEqualToNumber:@3], @"Woah,  subscript?");
    XCTAssertTrue([[os objectAtIndex:2] isEqualToNumber:@3], @"Seems legit");
    
    XCTAssertThrows([os objectAtIndex:100], @"I throw, just like arrays");
    
    NSSet *subset = [[NSSet alloc] initWithObjects:@0, @1, @2, @3, @4, @5, @6, @7, nil];
    
    BOOL res = YES;
    for (NSNumber *elem in os) {
        res = res && [subset containsObject:elem];
    }
    XCTAssertTrue(res, @"try that with an array");
    
    res = NO;
    for (NSNumber *elem in os) {
        res = res || [subset containsObject:elem];
    }
    XCTAssertTrue(res, @"yeah, it intersects, too");
    
    NSSet *nonintersects = [[NSSet alloc] initWithObjects:@7, @8, @9, nil];
    
    res = NO;
    for (NSNumber *elem in os) {
        res = res || [nonintersects containsObject:elem];
    }
    XCTAssertFalse(res, @"nope, no intersection");
}

@end
