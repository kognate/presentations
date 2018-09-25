//
//  KeyPathsTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "KeyPathsTests.h"
#import "KeyPaths.h"

@interface KeyPathsTests ()
@property (strong) KeyPaths *keypaths;

@end

@implementation KeyPathsTests
- (void)setUp
{
    [super setUp];
    self.keypaths = [[KeyPaths alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testKeyPaths {
    NSArray *filtered = [self.keypaths keypaths];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"Firstname = %@ or Firstname = %@",@"Sam",@"Alice"];
    NSArray *ar = [filtered filteredArrayUsingPredicate:_pred];
    XCTAssertTrue([ar count] == [filtered count], @"only sam and alice");
}

- (void) testNestingKeyPaths {
    NSArray *filtered = [self.keypaths nesting];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"Firstname = %@ or Firstname = %@",@"Sam",@"Alice"];
    NSArray *ar = [filtered filteredArrayUsingPredicate:_pred];
    XCTAssertEqual([ar count], [filtered count], @"only sam and alice");
    XCTAssertTrue([filtered count] > 0, @"only sam and alice");
}

- (void) testTooDeep {
    XCTAssertThrows([self.keypaths toodeep], @"This throws an error because of the nesting");
}

- (void) testBlockPred {
    XCTAssertTrue([self.keypaths blockPredicate], @"blocks work");
}
@end
