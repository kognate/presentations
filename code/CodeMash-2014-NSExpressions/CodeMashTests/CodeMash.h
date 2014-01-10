//
//  CodeMash.h
//  CodeMash
//
//  Created by Josh Smith on 1/9/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CodeMash : NSObject

/*! Allows access to the data array that gets passed in via init. */
@property (strong,nonatomic, readonly) NSArray *dataArray;

/*! The sortedDataArray contains the same information as the dataArray
 but has been sorted. */
@property (strong,nonatomic, readonly) NSArray *sortedDataArray;

- (id) initWithArray:(NSArray *) arrayOfNumbers;
- (id) initWithArray:(NSArray *) arrayOfObjects usingKey:(NSString *) keystring;

/*! returns the sum of the numbers in the array.  If the array does not contain
 numbers, this will raise
 */
- (NSNumber *) sum;
- (NSNumber *) min;
- (NSNumber *) max;
- (NSNumber *) mean;
- (NSNumber *) median;
- (NSNumber *) mmode;

- (NSNumber *) firstQuartile;
- (NSNumber *) thirdQuartile;

- (NSDictionary *) descriptiveStats;

@end


