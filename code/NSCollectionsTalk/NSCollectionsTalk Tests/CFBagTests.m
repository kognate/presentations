//
//  CFBagTests.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 11/15/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CFBagTests : XCTestCase
@end

@implementation CFBagTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicBag
{
    u_int32_t numbers[5];
    for (int i = 0; i < 5; i++) {
        numbers[i] = 5;
    }
    
    u_int32_t *find = calloc(sizeof(u_int32_t), 1);
    *find = 5;
    CFMutableBagRef bag = CFBagCreateMutable(CFAllocatorGetDefault(), 5, NULL);
    CFBagAddValue(bag, &find);
    //XCTAssert(CFBagGetCount(bag) == 5, @"should have 5 elements");
    long count = CFBagGetCountOfValue(bag, (void *)&find);
    //XCTAssert(count == 5, @"should be five");
}

@end
