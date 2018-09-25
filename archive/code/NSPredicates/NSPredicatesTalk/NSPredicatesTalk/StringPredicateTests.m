//
//  StringPredicateTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/20/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "StringPredicateTests.h"

@implementation StringPredicateTests

- (void) testEquality
{
    NSString *target = @"hello";
    NSPredicate *equal = [NSPredicate predicateWithFormat:@"self = %@",target];
    XCTAssertFalse([equal evaluateWithObject:@"world"], @"Nope");
    XCTAssertTrue([equal evaluateWithObject:@"hello"], @"Yep");
}

- (void) testContainsExample
{
    NSString *target = @"hello world";
    NSPredicate *greeting = [NSPredicate predicateWithFormat:@"self contains %@",@"hello"];
    XCTAssertTrue([greeting evaluateWithObject:target], @"I contain hello");
}

- (void) testBeginsWith
{
    NSPredicate *beginswith = [NSPredicate predicateWithFormat:@"self beginswith %@",@"hello"];
    
    XCTAssertTrue([beginswith evaluateWithObject:@"hello world"],@"");
    XCTAssertFalse([beginswith evaluateWithObject:@"Hello World"],@"");
    XCTAssertFalse([beginswith evaluateWithObject:@"codemash! Hello!"],@"");
}

- (void) testContains
{
    NSPredicate *contains = [NSPredicate
                             predicateWithFormat:@"self contains[cd] %@",@"hello"];
    
    XCTAssertTrue([contains evaluateWithObject:@"hello world"],@"");
    XCTAssertTrue([contains evaluateWithObject:@"Hello World"],@"");
    XCTAssertTrue([contains evaluateWithObject:@"codemash! Hello!"],@"");
    XCTAssertFalse([contains evaluateWithObject:@"codemash!"],@"");

}

- (void) testEndsWith
{
    NSPredicate *endswith = [NSPredicate predicateWithFormat:@"self endswith %@",@"hello"];
    XCTAssertTrue([endswith evaluateWithObject:@"world hello"],@"");
    XCTAssertFalse([endswith evaluateWithObject:@"Hello World"],@"");
    XCTAssertFalse([endswith evaluateWithObject:@"codemash! Hello!"],@"");
    XCTAssertFalse([endswith evaluateWithObject:@"codemash!"],@"");
    
}

- (void)testLike
{
    NSPredicate *like = [NSPredicate predicateWithFormat:@"self like %@",@"*star?"];
    XCTAssertFalse([like evaluateWithObject:@"destared"],@"");
    XCTAssertFalse([like evaluateWithObject:@"is staring"],@"");
    XCTAssertTrue([like evaluateWithObject:@"stars"], @"");
    XCTAssertTrue([like evaluateWithObject:@"deathstart"], @"");
    XCTAssertFalse([like evaluateWithObject:@"   "], @"");
}

- (void) testMatches
{
    NSPredicate *match = [NSPredicate predicateWithFormat:@"self matches '\\\\d+[a-z]'"];
    XCTAssertFalse([match evaluateWithObject:@"0A"],@"");
    XCTAssertTrue([match evaluateWithObject:@"0a"],@"");
    XCTAssertFalse([match evaluateWithObject:@"000000ab"],@"");
    XCTAssertTrue([match evaluateWithObject:@"000000c"],@"");
}

- (void) testMatchesValidation
{
    NSString *email = @"kognate@gmail.com";
    NSString *bademail = @"kognate@gmail. com";
    NSPredicate *_emailValid = [NSPredicate predicateWithFormat:@"self matches '[a-z+]+@[a-z]+\\\\.com'"];
    XCTAssertTrue([_emailValid evaluateWithObject:email], @"This email works");
    XCTAssertFalse([_emailValid evaluateWithObject:bademail], @"This one doesn't");
}

- (void) testTemplatedBegins
{
    NSPredicate *template = [NSPredicate predicateWithFormat:@"self = $MYSTRING"];
    
    NSPredicate *instance = [template predicateWithSubstitutionVariables:@{@"MYSTRING": @"Atlanta"}];
    XCTAssertTrue([instance evaluateWithObject:@"Atlanta"], @"Yep, atlanta");
    XCTAssertFalse([instance evaluateWithObject:@"Boston"], @"Wait a minute...?");
}
@end
