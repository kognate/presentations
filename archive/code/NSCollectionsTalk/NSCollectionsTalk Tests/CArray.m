//
//  CArray.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>

BOOL is_palindrome(char *tocheck) {
    unsigned long start_length = strlen(tocheck);
    unsigned long k, r;
    BOOL isapalindrome = YES;
    for (k = 0, r = start_length - 1; k < r; k++, r--)
    {
        isapalindrome = isapalindrome && (tocheck[k] == tocheck[r]);
    }
    return isapalindrome;
}

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

- (void) testStringReversal
{
    char *start = "hello world";
    unsigned long start_length = strlen(start);
    char *reversed = calloc(sizeof(char), start_length);
    
    while (*start) {
        start++;
    }
    
    for (unsigned long i = 0; i < start_length; i++) {
        start--;
        reversed[i] = *start;
    }
    printf("Reversed: <%s>",reversed);
    free(reversed);
    XCTAssertTrue(strcmp("dlrow olleh", reversed) == 0, @"should be reversed");
}

- (void) testStringReversalInPlace
{
    char start[] = "hello world";
    unsigned long start_length = strlen(start);
    unsigned long k, r;
    char holder;
    
    // hello k & r
    for (k = 0, r = start_length - 1; k < r; k++, r--)
    {
        holder = start[k];
        start[k] = start[r];
        start[r] = holder;
    }

    XCTAssertTrue(strcmp("dlrow olleh", start) == 0, @"should be reversed");
    
}

- (void) testPalindrome
{
    XCTAssertTrue(is_palindrome("gorby ybrog"), @"I'm a palindrome");
    XCTAssertFalse(is_palindrome("palindrome"), @"I'm not a palindrome");
}

- (void) testMonteCarloCArray
{
    int numruns = 100000;
    uint32_t *intarray = malloc(sizeof(int) * numruns);
    for (int i = 0;i < numruns; i++) {
        intarray[i] = arc4random_uniform(100);
    }
    int32_t sum = 0;

    for (int i = 0; i < numruns; i++) {
        int32_t dice_roll = intarray[dice_roll];
        if (dice_roll > 98) {
            sum += 58;
        } else if (dice_roll > 90) {
            sum += 35;
        } else if (dice_roll > 20) {
            sum += 30;
        } else {
            sum += 10;
        }
    }
    
    XCTAssertTrue(sum / numruns > 0, @"Should be > 0");
    
}

@end
