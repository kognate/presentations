//
//  StringPredicateTests.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/20/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "StringPredicateTests.h"

@implementation StringPredicateTests

- (void) testContainsExample
{
    NSPredicate *greeting = [NSPredicate predicateWithFormat:@"self contains %@",@"hello"];
    STAssertTrue([greeting evaluateWithObject:@"hello codemash"], @"");
}

- (void) testBeginsWith
{
    NSPredicate *beginswith = [NSPredicate predicateWithFormat:@"self beginswith %@",@"hello"];
    
    STAssertTrue([beginswith evaluateWithObject:@"hello world"],@"");
    STAssertFalse([beginswith evaluateWithObject:@"Hello World"],@"");
    STAssertFalse([beginswith evaluateWithObject:@"codemash! Hello!"],@"");
}

- (void) testContains
{
    NSPredicate *contains = [NSPredicate
                             predicateWithFormat:@"self contains[cd] %@",@"hello"];
    
    STAssertTrue([contains evaluateWithObject:@"hello world"],@"");
    STAssertTrue([contains evaluateWithObject:@"Hello World"],@"");
    STAssertTrue([contains evaluateWithObject:@"codemash! Hello!"],@"");
    STAssertFalse([contains evaluateWithObject:@"codemash!"],@"");

}

- (void) testEndsWith
{
    NSPredicate *endswith = [NSPredicate predicateWithFormat:@"self endswith %@",@"hello"];
    STAssertTrue([endswith evaluateWithObject:@"world hello"],@"");
    STAssertFalse([endswith evaluateWithObject:@"Hello World"],@"");
    STAssertFalse([endswith evaluateWithObject:@"codemash! Hello!"],@"");
    STAssertFalse([endswith evaluateWithObject:@"codemash!"],@"");
    
}

- (void)testLike
{
    NSPredicate *like = [NSPredicate predicateWithFormat:@"self like %@",@"*star?"];
    STAssertFalse([like evaluateWithObject:@"destared"],@"");
    STAssertFalse([like evaluateWithObject:@"is staring"],@"");
    STAssertTrue([like evaluateWithObject:@"stars"], @"");
    STAssertTrue([like evaluateWithObject:@"deathstart"], @"");
    STAssertFalse([like evaluateWithObject:@"   "], @"");
}

- (void) testMatches
{
    NSPredicate *match = [NSPredicate predicateWithFormat:@"self matches '\\\\d+[a-z]'"];
    STAssertFalse([match evaluateWithObject:@"0A"],@"");
    STAssertTrue([match evaluateWithObject:@"0a"],@"");
    STAssertFalse([match evaluateWithObject:@"000000ab"],@"");
    STAssertTrue([match evaluateWithObject:@"000000c"],@"");
}

- (void) testMatchesValidation
{
    NSString *email = @"kognate@gmail.com";
    NSString *bademail = @"kognate@gmail. com";
    NSPredicate *_emailValid = [NSPredicate predicateWithFormat:@"self matches '[a-z+]+@[a-z]+\\\\.com'"];
    STAssertTrue([_emailValid evaluateWithObject:email], @"This email works");
    STAssertFalse([_emailValid evaluateWithObject:bademail], @"This one doesn't");
}
@end
