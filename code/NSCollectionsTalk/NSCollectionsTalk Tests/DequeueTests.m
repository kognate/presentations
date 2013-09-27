//
//  DequeueTests.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UsingDequeue.h"

@interface DequeueTests : XCTestCase

@end

@implementation DequeueTests

- (void)testQueue
{
    UsingDequeue *queue = [[UsingDequeue alloc] init];
    [queue push:@"First"];
    [queue push:@"Second"];
    [queue push:@"Third"];
    XCTAssertTrue([queue length] == 3, @"should be 3 items");
    XCTAssertTrue([[queue objectAtIndex:1] isEqualToString:@"Second"], @"second item is Second");
    NSString *lastItem = [queue pop];
    XCTAssertTrue([queue length] == 2, @"should be 2 items");
    XCTAssertTrue([lastItem isEqualToString:@"Third"], @"The First!");
}

@end
