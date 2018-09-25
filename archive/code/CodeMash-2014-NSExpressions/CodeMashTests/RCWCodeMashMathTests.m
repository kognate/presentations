//
//  RCWCodeMashMathTests.m
//  CodeMash
//
//  Created by Josh Smith on 1/9/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CodeMash.h"
@interface RCWCodeMashMathTests : XCTestCase
@property (strong) CodeMash *b_first;
@property (strong) CodeMash *b_second;
@end

@implementation RCWCodeMashMathTests


- (void)setUp
{
    [super setUp];
    
    self.b_first = [[CodeMash alloc] initWithArray:@[@1, @3, @4]];
    self.b_second = [[CodeMash alloc] initWithArray:@[@7, @6, @3]];
}

- (void)testSum
{
    XCTAssertTrue([[self.b_first sum] isEqualToNumber:@8], @"sum is 8");
    XCTAssertTrue([[self.b_second sum] isEqualToNumber:@16], @"sum is 16");
}

- (void) testMin {
    XCTAssertTrue([[self.b_first min] isEqualToNumber:@1], @"min is 1");
    XCTAssertTrue([[self.b_second min] isEqualToNumber:@3], @"min is 3");
}

- (void) testMax {
    XCTAssertTrue([[self.b_first max] isEqualToNumber:@4], @"max is 4");
    XCTAssertTrue([[self.b_second max] isEqualToNumber:@7], @"max is 7");
}

- (void) testAverage {
    XCTAssertTrue([[self.b_first mean] isEqualToNumber:@(8.0/3.0)], @"mean is is 8/3");
    XCTAssertTrue([[self.b_second mean] isEqualToNumber:@(16.0/3.0)], @"max is 16/3");
}

- (void) testMedian {
    XCTAssertTrue([[self.b_first median] isEqualToNumber:@3], @"median is 3");
    XCTAssertTrue([[self.b_second median] isEqualToNumber:@6], @"median is 6");
}

- (void) testMode {
    CodeMash *b = [[CodeMash alloc] initWithArray:@[ @4, @4, @3, @9, @10, @4]];
    XCTAssertTrue([[self.b_first mmode] isEqualToNumber:@1], @"mode is 1");
    XCTAssertTrue([[self.b_second mmode] isEqualToNumber:@3], @"mode is 3");
    XCTAssertTrue([[b mmode] isEqualToNumber:@4], @"mode is 4");
}

// > summary(c(4,4,3,9,10,4,8,7,6,11,10,12,12));
// Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
// 3.000   4.000   8.000   7.692  10.000  12.000

- (void) testQuartiles {
    CodeMash *b = [[CodeMash alloc] initWithArray:@[ @4, @4, @3, @9, @10, @4, @8, @7, @6, @11, @10, @12, @12]];
    NSDictionary *res = [b descriptiveStats];
    XCTAssertTrue([res[@"mode"] isEqualToNumber:@4], @"mode is still 4");
    XCTAssertTrue([res[@"min"] isEqualToNumber:@3], @"min is 3");
    XCTAssertTrue([res[@"1stQuartile"] isEqualToNumber:@4], @"q_1 is 4");
    XCTAssertTrue([res[@"3rdQuartile"] isEqualToNumber:@10], @"q_3 is 10");
}

- (void) testInitKeyPath  {
    NSArray *d = @[ @{ @"Name" : @"first", @"price" : @23.00 },
                    @{ @"Name" : @"second", @"price" : @32.00 } ];
    CodeMash *b = [[CodeMash alloc] initWithArray:d usingKey:@"price"];
    XCTAssertTrue([[b min] isEqualToNumber:@23.00], @"min is correct");
}

- (void) throwEncapsulation {
    CodeMash *b = [[CodeMash alloc] initWithArray:@[ @1, @2, @"hello", @4]];
    XCTAssertNil(b, @"I will be nil, unless I assert");
}

- (void) testWillThrow {
    XCTAssertThrows([self throwEncapsulation], @"I should be throwing");
}



@end
