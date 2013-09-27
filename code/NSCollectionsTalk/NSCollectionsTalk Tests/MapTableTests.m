//
//  MapTableTests.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MapTableTests : XCTestCase

@end

@implementation MapTableTests

- (void)testMaps
{
    NSMapTable *mt = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                               valueOptions:NSMapTableStrongMemory
                                                   capacity:3];
    [mt setObject:@"hello" forKey:@20];
    [mt setObject:@"world" forKey:@"twenty"];
    [mt setObject:@20 forKey:mt];
    
    NSValue *v = [NSValue valueWithPoint:NSMakePoint(10,20)];
    [mt setObject:[NSData dataWithBytes:"one" length:3] forKey:v];
    
    NSNumber *n = [mt objectForKey:mt];

    XCTAssertTrue([[mt objectForKey:@20] isEqualToString:@"hello"], @"hey, it worked");
    XCTAssertTrue([[mt objectForKey:@"twenty"] isEqualToString:@"world"], @"hey, it worked");
    XCTAssertTrue([n isEqualToNumber:@20] , @"Can set self as key");
    XCTAssertTrue([[mt objectForKey:v] length] == 3, @"woah");
}

- (void)testAwesomeBug
{
    NSMapTable *mt = [[NSMapTable alloc] init];
    [mt setObject:@"hello" forKey:@20];
    [mt setObject:@"world" forKey:@"twenty"];
    [mt setObject:@20 forKey:mt];
    
    NSNumber *n = [mt objectForKey:mt];
    
    XCTAssertTrue([[mt objectForKey:@20] isEqualToString:@"hello"], @"hey, it worked");
    XCTAssertTrue([[mt objectForKey:@"twenty"] isEqualToString:@"world"], @"hey, it worked");
    XCTAssertNil(n, @"Can't set self as the key");

    [mt setObject:[NSData dataWithBytes:"one" length:3] forKey:[NSValue valueWithPoint:NSMakePoint(10, 20)]];
    
    n = [mt objectForKey:mt];
    
    XCTAssertTrue([[mt objectForKey:@"twenty"] isEqualToString:@"world"], @"hey, it worked");
    XCTAssertTrue([n isEqualToNumber:@20] , @"Can set self as key");
    XCTAssertTrue([[mt objectForKey:[NSValue valueWithPoint:NSMakePoint(10, 20)]] length] == 3, @"woah");

    }

@end
