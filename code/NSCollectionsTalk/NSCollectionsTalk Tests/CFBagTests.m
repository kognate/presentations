//
//  CFBagTests.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 12/17/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CFBagTests : XCTestCase

@end

@implementation CFBagTests


- (void)testBags
{
    int *a = malloc(sizeof(int));
    int *b = malloc(sizeof(int));
    int *c = malloc(sizeof(int));
    int *d = malloc(sizeof(int));
    int *e = malloc(sizeof(int));
    
    *a = 1;
    *b = 2;
    *c = 3;
    *d = 4;
    *e = 5;
    int **bagvals = malloc(sizeof(int *) * 9);
    bagvals[0] = a; bagvals[9] = a;
    bagvals[1] = b; bagvals[8] = a;
    bagvals[2] = c; bagvals[7] = c;
    bagvals[3] = d; bagvals[6] = c;
    bagvals[4] = c; bagvals[5] = c;

    CFBagRef bag = CFBagCreate(CFAllocatorGetDefault(), (const void **)bagvals, 10, NULL);
    XCTAssert(CFBagGetCount(bag) == 10);
    XCTAssert(CFBagGetCountOfValue(bag, (const void *)a) == 3);
    XCTAssert(CFBagContainsValue(bag, (const void *)a));
    XCTAssertFalse(CFBagContainsValue(bag, (const void *)e));
    CFRelease(bag);
    free(a); free(b); free(c); free(d); free(e);
}

- (void)testMutableBags
{
    int *a = malloc(sizeof(int));
    int *b = malloc(sizeof(int));
    int *c = malloc(sizeof(int));
    int *d = malloc(sizeof(int));
    int *e = malloc(sizeof(int));
    
    *a = 1;
    *b = 2;
    *c = 3;
    *d = 4;
    *e = 5;

    CFMutableBagRef mutablebag = CFBagCreateMutable(CFAllocatorGetDefault(), 10, NULL);
    CFBagAddValue(mutablebag, a);
    CFBagAddValue(mutablebag, a);
    CFBagAddValue(mutablebag, a);
    CFBagAddValue(mutablebag, b);
    CFBagAddValue(mutablebag, c);
    CFBagAddValue(mutablebag, d);
    CFBagAddValue(mutablebag, d);
    CFBagAddValue(mutablebag, d);
    CFBagAddValue(mutablebag, d);
    CFBagAddValue(mutablebag, d);
    
    XCTAssert(CFBagGetCount(mutablebag) == 10);
    XCTAssert(CFBagGetCountOfValue(mutablebag, (const void *)a) == 3);
    XCTAssert(CFBagContainsValue(mutablebag, (const void *)a));
    XCTAssertFalse(CFBagContainsValue(mutablebag, (const void *)e));
    CFRelease(mutablebag);
    free(a); free(b); free(c); free(d); free(e);
}


@end
