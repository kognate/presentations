//
//  CodeMashTests.m
//  CodeMashTests
//
//  Created by Josh Smith on 1/9/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>


@implementation NSNumber (CodeMash)

- (NSNumber *) multiplyBy:(NSNumber *) numby {
    NSExpression *mult = [NSExpression expressionForConstantValue:self];
    NSExpression *multby = [NSExpression expressionForConstantValue:numby];
    NSExpression *domath = [NSExpression expressionForFunction:@"multiply:by:" arguments:@[mult, multby] ];
    return [domath expressionValueWithObject:nil context:nil];
}

- (NSNumber *) modulo:(NSNumber *) mod {
    NSExpression *modu = [NSExpression expressionForConstantValue:self];
    NSExpression *multby = [NSExpression expressionForConstantValue:mod];
    NSExpression *domath = [NSExpression expressionForFunction:@"modulus:by:" arguments:@[modu, multby] ];
    return [domath expressionValueWithObject:nil context:nil];
}

- (NSNumber *) abs {
    NSExpression *current = [NSExpression expressionForConstantValue:self];
    NSExpression *domath = [NSExpression expressionForFunction:@"abs:" arguments:@[ current ]];
    return [domath expressionValueWithObject:nil context:nil];
}

- (NSNumber *) ceil {
    NSExpression *current = [NSExpression expressionForConstantValue:self];
    NSExpression *domath = [NSExpression expressionForFunction:@"ceiling:" arguments:@[ current ]];
    return [domath expressionValueWithObject:nil context:nil];
}

- (NSNumber *) floor {
    NSExpression *current = [NSExpression expressionForConstantValue:self];
    NSExpression *domath = [NSExpression expressionForFunction:@"floor:" arguments:@[ current ]];
    return [domath expressionValueWithObject:nil context:nil];
}

@end

@interface CodeMashTests : XCTestCase

@end

@implementation CodeMashTests

- (void) testCeil {
    NSNumber *n = [NSNumber numberWithFloat:3.14159];
    NSNumber *result = [n ceil];
    XCTAssertEqualObjects(result, @4, @"Not very Pi");
}

- (void) testFloor {
    NSNumber *n = [NSNumber numberWithFloat:3.14159];
    NSNumber *result = [n floor];
    XCTAssertEqualObjects(result, @3, @"Not very Pi, either");
}

- (void) testABs {
    NSNumber *n = [NSNumber numberWithInt:-100];
    NSNumber *result = [n abs];
    XCTAssertEqualObjects(@100, result, @"I'm 100");
}

- (void) testModulo {
    NSNumber *n = @21;
    NSNumber *result = [n modulo:@3];
    XCTAssertEqualObjects(@0, result, @"I'm zero");
}

- (void) testCategoryMultiply {
    NSNumber *n = @20;
    XCTAssertEqualObjects([n multiplyBy:@10], @200, @"I am 200");
}



- (void) testUnbox
{
    int res = [@10 intValue] + [@10 intValue];
    XCTAssert(res = 20, @"I am 20!");
}


- (void) testAdd {
    NSExpression *add = [NSExpression expressionWithFormat:@"%@ + %@",@20, @10];
    XCTAssertEqualObjects(@30, [add expressionValueWithObject:Nil context:nil],@"I'm 30");
}


- (void) testSubtract {
    
    NSExpression *sub = [NSExpression expressionWithFormat:@"%@ - %@",@20, @10];
    XCTAssertEqualObjects([NSNumber numberWithInt:10], [sub expressionValueWithObject:Nil context:nil],@"I'm 10");
    
}


- (void) testMultiply {
    
    NSExpression *mult = [NSExpression expressionWithFormat:@"%@ * %@",@20, @10];
    XCTAssertEqualObjects(@200, [mult expressionValueWithObject:Nil context:nil],@"I'm 200");
    
}


- (void) testDivide {
    
    NSExpression *divide = [NSExpression expressionWithFormat:@"%@ / %@",@20, @10];
    XCTAssertEqualObjects(@2, [divide expressionValueWithObject:nil context:nil],@"I'm 2");
}


- (void) testIntersectPredicate {
    
    NSSet *firstSet = [NSSet setWithArray:@[ @1, @5, @7]];
    NSSet *secondSet = [NSSet setWithArray:@[ @3, @7, @11]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"NOT (self in %@)",secondSet];
    NSSet *filtered = [firstSet filteredSetUsingPredicate:_pred];
    NSSet *target = [NSSet setWithArray:@[@1, @5 ]];
    XCTAssertEqualObjects(filtered, target, @"Using a predicate");
}

- (void) testIntersection
{
    NSSet *firstSet = [NSSet setWithArray:@[ @1, @5, @7]];
    NSSet *secondSet = [NSSet setWithArray:@[ @3, @7, @11]];
    
    NSExpression *a = [NSExpression expressionForConstantValue:firstSet];
    NSExpression *b =[NSExpression expressionForConstantValue: secondSet];
    NSExpression *e = [NSExpression expressionForMinusSet:a with:b];
    
    NSSet *result = [e expressionValueWithObject:nil context:nil];
    NSSet *target = [NSSet setWithArray:@[@1, @5 ]];
    
    XCTAssertEqualObjects(result, target, @"I'm the minus");
    
}


- (void) testPredicateConstruction
{
    NSExpression *leftHand = [NSExpression expressionForConstantValue:@"first"];
    NSExpression *rightHand = [NSExpression expressionForVariable:@"TARGETNAME"];
    NSPredicate *categoryNamePredicateTemplate = [[NSComparisonPredicate alloc] initWithLeftExpression:leftHand
                                                                                       rightExpression:rightHand
                                                                                              modifier:NSDirectPredicateModifier
                                                                                                  type:NSLikePredicateOperatorType
                                                                                               options:0];
    
    NSPredicate *run = [categoryNamePredicateTemplate predicateWithSubstitutionVariables:@{@"TARGETNAME" : @"?ir*"}];
    XCTAssert([run evaluateWithObject:nil], @"should work");
}


- (void) testPredicateAll
{
    NSArray *expressions = @[
                             [NSExpression expressionForConstantValue:@2],
                             [NSExpression expressionForConstantValue:@4],
                             [NSExpression expressionForConstantValue:@6],
                             [NSExpression expressionForConstantValue:@8],
                             ];
    NSExpression *leftHand = [NSExpression expressionForAggregate:expressions];
    NSExpression *rightHand = [NSExpression expressionForConstantValue:@10];
    NSPredicate *anyPred = [[NSComparisonPredicate alloc] initWithLeftExpression:leftHand
                                                                 rightExpression:rightHand
                                                                        modifier:NSAllPredicateModifier
                                                                            type:NSLessThanOrEqualToPredicateOperatorType
                                                                         options:0];
    
    XCTAssert([anyPred evaluateWithObject:nil], @"should work");
}






@end
