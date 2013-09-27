//
//  CArray.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CArray : XCTestCase

@end

@implementation CArray

- (void)testCArray
{
    uint32_t *intarray = malloc(sizeof(int) * 10);
    for (int i = 0; i < 10; i++) {
        intarray[i] = arc4random();
    }
    NSLog(@">>>>>>   %d",intarray[5]);
    free(intarray);
}

@end
