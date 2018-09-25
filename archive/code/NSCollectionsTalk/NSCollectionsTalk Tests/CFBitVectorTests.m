//
//  CFBitVectorTests.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 11/15/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CFBitVectorTests : XCTestCase

@end

@implementation CFBitVectorTests

- (void)testBitVector
{
    
    CFMutableBitVectorRef bv = CFBitVectorCreateMutable(CFAllocatorGetDefault(), 5);

    CFBitVectorFlipBitAtIndex(bv, 1);
    XCTAssert(CFBitVectorGetBitAtIndex(bv, 1) == 1, @"one is true");
    XCTAssert(CFBitVectorGetBitAtIndex(bv, 0) == 0, @"zero is false");
    
    CFRange range = CFRangeMake(0, 5);
    CFIndex count = CFBitVectorGetCountOfBit(bv, range, 1);
    XCTAssert(count == 1, @"should have five");
    CFRelease(bv);
}

@end
