//
//  PrioQueueTests.h
//  NSCollectionsTalk
//
//  Created by Josh Smith on 3/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@protocol RCWPrioCanCompare <NSObject>

- (CFComparisonResult) compareWith:(id<RCWPrioCanCompare>) otherObj;
- (NSString *) comparisonValue;

@end

@interface RCWPrioQueue : NSEnumerator

- (NSUInteger) count;
- (void) push:(id<RCWPrioCanCompare>) obj;
- (id) pop;
- (id) front;

@end

@interface PrioQueueTests : XCTest

@end
