//
//  ExpressionTest.m
//  NSPredicatesTalk
//
//  Created by Josh Smith on 11/15/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ExpressionTest : XCTestCase

@end

@implementation ExpressionTest

- (void)testSimpleAddition
{
    NSExpression *expression = [NSExpression expressionWithFormat:@"3 + 2"];
    NSNumber *result = [expression expressionValueWithObject:nil context:nil];
    XCTAssert([result intValue] == 5, @"I'm five");
}

- (void) testComplicatedAddition
{
    NSExpression *expression = [NSExpression expressionWithFormat:@"(3 + 2) + (3 * 2)"];
    NSNumber *result = [expression expressionValueWithObject:nil context:nil];
    XCTAssert([result intValue] == 11, @"I'm eleven");
}

- (void) testComplexAddition
{
    NSExpression *array = [NSExpression expressionForConstantValue:@[ @5, @6]];
    NSExpression *toEvaluate = [NSExpression expressionForFunction:@"sum:" arguments:@[ array ]];
    NSNumber *result = [toEvaluate expressionValueWithObject:nil context:nil];
    XCTAssert([result intValue] == 11, @"I am 11");
}

- (void) testBuildPredicate
{
    NSExpression *lhs = [NSExpression expressionWithFormat:@"self"];
    NSExpression *rhs = [NSExpression expressionWithFormat:@"%@",@"hello"];
    NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                rightExpression:rhs
                                                                       modifier:NSDirectPredicateModifier
                                                                           type:NSEqualToPredicateOperatorType options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
    XCTAssert([predicate evaluateWithObject:@"hello"], @"I'm a working predicate");

}

@end
