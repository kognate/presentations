//
//  main.m
//  NSCollectionsTalk
//
//  Created by Josh Smith on 9/26/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Simple Monte Carlo
        
        NSMapTable *table = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                      valueOptions:NSMapTableStrongMemory
                                                          capacity:10];
        [table setObject:@(10) forKey:@20];
        [table setObject:@(30) forKey:@90];
        [table setObject:@(35) forKey:@98];
        [table setObject:@(58) forKey:@100];
        
        NSMutableIndexSet *s = [[NSMutableIndexSet alloc]init];
        [s addIndex:20];
        [s addIndex:90];
        [s addIndex:98];
        [s addIndex:100];
        
        int sum = 0;
        int rounds = 100000;
        for (int i = 0; i < rounds; i++) {
            int idx = arc4random_uniform(100);
            NSUInteger found_idx = [s indexGreaterThanIndex:idx];
            if (found_idx != NSNotFound) {
                sum += [[table objectForKey:@(found_idx)] intValue];
            } else {
                NSLog(@"woops");
            }
        }
        NSLog(@"%d", sum / rounds);
        
    }
    return 0;
}

