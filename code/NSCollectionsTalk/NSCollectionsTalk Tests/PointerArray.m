//
//  PointerArray.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PointerArray : XCTestCase

@end

@implementation PointerArray

- (void)testNULL
{
    NSPointerArray *p = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];
    XCTAssertTrue([p count] == 0, @"it's empty!");
    XCTAssertThrows([p pointerAtIndex:5], @"I'm null");

    // try that with an array
    p.count = 10;
    
    XCTAssertTrue([p count] == 10, @"Now it's NOT");
    XCTAssertTrue([p pointerAtIndex:5] == NULL, @"I'm null");
    char *ht = malloc(sizeof(char) * 20);
    bzero(ht, 20);
    strcpy(ht, "12345678901234567890");
    [p addPointer:(void *)ht];
    XCTAssertTrue(strcmp(ht, (const char *)[p pointerAtIndex:10]) == 0, @"ug");
}

- (void) testOther
{
    NSPointerArray *p = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    [p addPointer:(__bridge void *)@5];
    [p addPointer:(__bridge void *)@10];
    XCTAssertTrue([p count] == 2, @"has 2 items");
    NSNumber *b = [p pointerAtIndex:0];
    XCTAssertTrue([b isEqualToNumber:@5], @"it's a 5");
}

@end
