//
//  CodeMash.m
//  CodeMash
//
//  Created by Josh Smith on 1/9/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//


#import "CodeMash.h"

@interface CodeMash ()
@property (strong,nonatomic) NSArray *sortedDataArray;
@property (strong,nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSCache *cache;
@end

@implementation CodeMash

- (id) initWithArray:(NSArray *) arrayOfNumbers {
    BOOL clean = YES;
    
    if (self = [super init]) {
        self.dataArray = arrayOfNumbers;
        @try {
            self.sortedDataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b)
                                    {
                                        return [a compare:b];
                                    }];
        }
        @catch (NSException *exception) {
            clean = NO;
        }
        self.cache = [[NSCache alloc] init];
    }
    NSAssert(clean,@"If I'm not clean, the inputs are bad");
    return clean ? self : nil;
}

- (id) initWithArray:(NSArray *)arrayOfObjects usingKey:(NSString *)keystring {
    NSArray *_res = [arrayOfObjects valueForKeyPath:keystring];
    return [self initWithArray:_res];
}

- (NSNumber *) methodWithName:(NSString *) fname {
    NSNumber *res = [self.cache objectForKey:fname];
    
    if (res == nil) {
        NSExpression *args = [NSExpression expressionForConstantValue:self.dataArray];
        NSExpression *n = [NSExpression expressionForFunction:fname arguments:@[ args ]];
        
        if ([fname isEqualToString:@"mode:"]) {
            res = [[n expressionValueWithObject:nil context:nil] lastObject];
        } else {
            res = [n expressionValueWithObject:nil context:nil];
        }
        [self.cache setObject:res forKey:fname];
    }
	return res;
}

- (NSNumber *) sum {
    return [self methodWithName:@"sum:"];
}

- (NSNumber *) min { return [self methodWithName:@"min:"]; }
- (NSNumber *) max { return [self methodWithName:@"max:"]; }
- (NSNumber *) mean { return [self methodWithName:@"average:"]; }
- (NSNumber *) median { return [self methodWithName:@"median:"]; }
- (NSNumber *) mmode { return [self methodWithName:@"mode:"]; }
- (NSNumber *) stddev { return [self methodWithName:@"stddev:"]; }

- (NSNumber *) firstQuartile {
    NSPredicate *_fq = [NSPredicate predicateWithFormat:@"self between {%@, %@}",[self min],[self median]];
    NSArray *ar = [self.sortedDataArray filteredArrayUsingPredicate:_fq];
    
    NSExpression *args = [NSExpression expressionForConstantValue:ar];
	NSExpression *n = [NSExpression expressionForFunction:@"median:" arguments:@[ args ]];
    return [n expressionValueWithObject:nil context:nil];
}

- (NSNumber *) thirdQuartile {
    NSPredicate *_fq = [NSPredicate predicateWithFormat:@"self between {%@, %@}",[self median],[self max]];
    NSArray *ar = [self.sortedDataArray filteredArrayUsingPredicate:_fq];
    
    NSExpression *args = [NSExpression expressionForConstantValue:ar];
	NSExpression *n = [NSExpression expressionForFunction:@"median:" arguments:@[ args ]];
    return [n expressionValueWithObject:nil context:nil];
}

- (NSDictionary *) descriptiveStats {
    return @{ @"min" : [self min],
              @"max" : [self max],
              @"mean" : [self mean],
              @"median" : [self median],
              @"mode" : [self mmode],
              @"stddev" : [self stddev],
              @"1stQuartile": [self firstQuartile],
              @"3rdQuartile": [self thirdQuartile],
              };
}

@end


