//
//  BetweenTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 11/15/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NestKey : NSObject
@property (strong) NSNumber *key;
@end

@implementation NestKey
@end


@interface ToNest : NSObject
@property (strong) NestKey *nested;
@end

@implementation ToNest
@end

@interface KPStuff : NSObject
@property (strong) ToNest *one;
@end

@implementation KPStuff
@end



@interface BetweenTests : XCTestCase

@end

@implementation BetweenTests

- (void) testSimple
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1 == 1"];
    XCTAssert([predicate evaluateWithObject:nil], @"Reality is not broken");
    
    predicate = [NSPredicate predicateWithFormat:@"2 > 1"];
    XCTAssert([predicate evaluateWithObject:nil], @"Reality is not broken");
    
    predicate = [NSPredicate predicateWithFormat:@"1 < 2"];
    XCTAssert([predicate evaluateWithObject:nil], @"Reality is not broken");
}

- (void) testSimpleTwo
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == 1"];
    XCTAssert([predicate evaluateWithObject:@1], @"Reality is not broken");
    
    predicate = [NSPredicate predicateWithFormat:@"self > 1"];
    XCTAssert([predicate evaluateWithObject:@2], @"Reality is not broken");
    
    predicate = [NSPredicate predicateWithFormat:@"1 < self"];
    XCTAssert([predicate evaluateWithObject:@2], @"Reality is not broken");
}

- (void) testKeyPaths
{
    
    KPStuff *stuff = [[KPStuff alloc] init];
    stuff.one = [[ToNest alloc] init];
    stuff.one.nested = [[NestKey alloc] init];
    stuff.one.nested.key = @10;
    
    [stuff setValue:@10 forKeyPath:@"one.nested.key"];
    NSPredicate *kppred = [NSPredicate predicateWithFormat:@"self.one.nested.key == %@",@10];
    XCTAssert([kppred evaluateWithObject:stuff], @"it works!");
    
}

- (void) testBetween
{
    NSPredicate *find = [NSPredicate predicateWithFormat:@"self between {2,5}"];
    XCTAssert([find evaluateWithObject:@3], @"three is between 2 and 5");
    XCTAssert([find evaluateWithObject:@2], @"two is between 2 and 5");
    XCTAssertFalse([find evaluateWithObject:@6], @"six is not");
}

- (void) testDatesBetween
{
    NSDate *start = [NSDate dateWithTimeIntervalSinceNow:-30];
    NSDate *end = [NSDate dateWithTimeIntervalSinceNow:10];
    NSPredicate *toCheck = [NSPredicate predicateWithFormat:@"self between {%@,%@}",start,end];
    XCTAssert([toCheck evaluateWithObject:[NSDate date]], @"currently in range");
    XCTAssertFalse([toCheck evaluateWithObject:[NSDate dateWithTimeIntervalSince1970:0]], @"but I'm not");
}

- (void) testIn
{
    NSSet *checkIn = [NSSet setWithObjects:@"Bob",@"Bill", @"Jim", nil];
    NSPredicate *toCheck = [NSPredicate predicateWithFormat:@"self in %@",checkIn];
    
    XCTAssert([toCheck evaluateWithObject:@"Bill"], @"Bill is in");

    NSPredicate *nextCheck = [NSPredicate predicateWithFormat:@"self in {%@}", @"Sam"];
    XCTAssert([nextCheck evaluateWithObject:@"Sam"], @"Sam is in");
}


@end
