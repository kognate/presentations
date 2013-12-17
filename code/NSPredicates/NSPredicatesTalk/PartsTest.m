//
//  PartsTest.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 11/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PartsTest : XCTestCase

@end

@implementation PartsTest

- (void) testAnd
{
    NSPredicate *first = [NSPredicate predicateWithFormat:@"self > 5"];
    NSPredicate *second = [NSPredicate predicateWithFormat:@"self < 10"];
    NSPredicate *all = [NSCompoundPredicate andPredicateWithSubpredicates:@[ first, second]];
    XCTAssert([all evaluateWithObject:@6], @"six works");
    XCTAssertFalse([all evaluateWithObject:@11], @"11 doesn't");
}

- (void) testNot
{
    
    NSPredicate *first = [NSPredicate predicateWithFormat:@"self > 5"];
    NSPredicate *notFirst = [NSCompoundPredicate notPredicateWithSubpredicate:first];
    XCTAssertFalse([notFirst evaluateWithObject:@6], @"six doesn't work");
    XCTAssert([notFirst evaluateWithObject:@3], @"3 works");
    
}

- (void) testOr
{
    NSPredicate *first = [NSPredicate predicateWithFormat:@"self > 5"];
    NSPredicate *second = [NSPredicate predicateWithFormat:@"self < 10"];
    NSPredicate *all = [NSCompoundPredicate orPredicateWithSubpredicates:@[ first, second]];
    XCTAssert([all evaluateWithObject:@6], @"six works");
    XCTAssert([all evaluateWithObject:@11], @"11 works now");
}

BOOL thisIsTerrible(NSString * _myarg) {
    BOOL _res = NO;
    if ([[_myarg substringToIndex:2] isEqualToString:@"CH"]) {
        if ([_myarg length] > 3) {
            if ([[_myarg componentsSeparatedByString:@"broken"] count] == 1) {
                if ([_myarg length] < 20) {
                    NSCharacterSet *s = [NSCharacterSet decimalDigitCharacterSet];
                    if ([[_myarg componentsSeparatedByCharactersInSet:s] count] > 1) {
                        if ([[_myarg componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] count] == 1) {
                            _res = YES;
                        }
                    }
                }
            }
        }
    }
    return _res;
}

- (void) testTerrible {
    NSArray *truestrings = @[ @"CH1hello",@"CH00"];
    NSArray *falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                           @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];
    
    [truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue(thisIsTerrible(obj), @"This should be true");
     }];
    
    [falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse(thisIsTerrible(obj), @"This should be false");
     }];
}

BOOL predicatesThisIsTerrible(NSString *_myarg) {
    NSPredicate *beginsWithCH = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *longEnough = [NSPredicate predicateWithFormat:@"SELF.length > 3"];
    NSPredicate *shortEnough = [NSPredicate predicateWithFormat:@"SELF.length < 20"];
    NSPredicate *containsDigit = [NSPredicate predicateWithFormat:@"SELF matches '.*\\\\d.*'"];
    NSPredicate *containsSpace = [NSPredicate predicateWithFormat:@"SELF contains ' '"];
    NSPredicate *containsBroken = [NSPredicate predicateWithFormat:@"SELF contains 'broken'"];
    NSPredicate *notContainsBroken = [NSCompoundPredicate notPredicateWithSubpredicate:containsBroken];
    NSPredicate *notContainsSpace = [NSCompoundPredicate notPredicateWithSubpredicate:containsSpace];
    
    NSArray *_preds = @[ beginsWithCH, longEnough, shortEnough, notContainsBroken,
                         notContainsSpace, containsDigit];
    
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}



- (void) testPredicateTerrible {
    NSArray *truestrings = @[ @"CH1hello",@"CH00"];
    NSArray *falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                               @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];
    
    [truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue(predicatesThisIsTerrible(obj), @"This should be true");
     }];
    
    [falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse(predicatesThisIsTerrible(obj), @"This should be false");
     }];
}

BOOL predicatesThisIsTerribleShort(NSString *_myarg) {
    
    NSPredicate *one = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *two = [NSPredicate predicateWithFormat:@"SELF.length > 3 AND self.length < 20"];
    
    NSString *lps = @"SELF matches '.*\\\\d.*' and NOT(SELF contains ' ') and NOT(SELF contains 'broken')";
    NSPredicate *three = [NSPredicate predicateWithFormat:lps];
    
    NSArray *_preds = @[ one, two, three ];
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}

- (void) testPredicateTerribleShort {
    NSArray *truestrings = @[ @"CH1hello",@"CH00"];
    NSArray *falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                               @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];
    
    [truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue(predicatesThisIsTerribleShort(obj), @"This should be true");
     }];
    
    [falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse(predicatesThisIsTerribleShort(obj), @"This should be true");
     }];
}

BOOL thisIsReallyTerrible(NSString *_myarg) {
    BOOL _res = NO;
    if ([_myarg length] > 3) {
        if ([_myarg length] < 20) {
            NSCharacterSet *s = [NSCharacterSet decimalDigitCharacterSet];
            if ([[_myarg componentsSeparatedByCharactersInSet:s] count] > 1) {
                NSCharacterSet *w = [NSCharacterSet whitespaceCharacterSet];
                if ([[_myarg componentsSeparatedByCharactersInSet:w] count] == 1) {
                    if ([[_myarg substringToIndex:2] isEqualToString:@"CH"]) {
                        if ([[_myarg componentsSeparatedByString:@"broken"] count] == 1) {
                            _res = YES;
                        }
                    } else if ([[_myarg substringToIndex:2] isEqualToString:@"HC"]) {
                        if ([[_myarg componentsSeparatedByString:@"broken"] count] > 1) {
                            _res = YES;
                        }
                    }
                }
            }
        }
    }
    return _res;
}

- (void) testIsThisReallyTerrible {
    NSArray *truestrings = @[ @"CH1hello",@"CH00"];
    NSArray *falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                               @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];

    [truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue(thisIsReallyTerrible(obj), @"This should be true");
     }
     ];
    
    [falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse(thisIsReallyTerrible(obj), @"This should be true");
     }
     ];
    
    XCTAssertTrue(thisIsReallyTerrible(@"HCbroken1"), @"Yep, it works");
    XCTAssertFalse(thisIsReallyTerrible(@"HCbroken"), @"Yep, it works");
}

BOOL predicatesTIRT(NSString *_myarg) {
    NSPredicate *beginsWithCH = [NSPredicate predicateWithFormat:@"SELF beginswith 'CH'"];
    NSPredicate *beginsWithHC = [NSPredicate predicateWithFormat:@"SELF beginswith 'HC'"];
    NSPredicate *longEnough = [NSPredicate predicateWithFormat:@"SELF.length > 3"];
    NSPredicate *shortEnough = [NSPredicate predicateWithFormat:@"SELF.length < 20"];
    NSPredicate *containsDigit = [NSPredicate predicateWithFormat:@"SELF matches '.*\\\\d.*'"];
    NSPredicate *containsSpace = [NSPredicate predicateWithFormat:@"SELF contains ' '"];
    NSPredicate *containsBroken = [NSPredicate predicateWithFormat:@"SELF contains 'broken'"];
    NSPredicate *notCB = [NSCompoundPredicate notPredicateWithSubpredicate:containsBroken];
    NSPredicate *notCS = [NSCompoundPredicate notPredicateWithSubpredicate:containsSpace];
    
    NSArray *_ch = [NSArray arrayWithObjects:beginsWithCH,notCB, nil];
    NSPredicate *chnotbroken = [NSCompoundPredicate andPredicateWithSubpredicates:_ch];
    NSArray *_hc = [NSArray arrayWithObjects:beginsWithHC,containsBroken,nil];
    NSPredicate *hcbroken = [NSCompoundPredicate andPredicateWithSubpredicates:_hc];
    
    NSArray *_chhc = [NSArray arrayWithObjects:chnotbroken,hcbroken, nil];
    NSPredicate *begins = [NSCompoundPredicate orPredicateWithSubpredicates:_chhc];
    
    NSArray *_preds = [NSArray arrayWithObjects:begins,
                       longEnough,
                       shortEnough,
                       containsDigit,
                       notCS,
                       nil];
    
    NSPredicate *main = [NSCompoundPredicate andPredicateWithSubpredicates:_preds];
    return [main evaluateWithObject:_myarg];
}

- (void) testIsThisReallyTerriblePredicates {
    NSArray *truestrings = @[ @"CH1hello",@"CH00"];
    NSArray *falsestrings = @[ @"CH1hello ",@"HH1hello", @"CH", @"CHbroken1",
                               @"CHaaafdddddddsssajjajjajfjfjjajfjajjf1"];
    
    [truestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertTrue(predicatesTIRT(obj), @"This should be true");
     }
     ];
    
    [falsestrings enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         XCTAssertFalse(predicatesTIRT(obj), @"This should be true");
     }
     ];
    
    XCTAssertTrue(predicatesTIRT(@"HCbroken1"), @"Yep, it works");
    XCTAssertFalse(predicatesTIRT(@"HCbroken"), @"Yep, it works");
}

@end
