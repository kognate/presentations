//
//  KeyPaths.h
//  NSPredicatesTalk
//
//  Created by Josh Smith on 10/26/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyPaths : NSObject

- (NSArray *) keypaths;
- (NSArray *) nesting;
- (NSArray *) toodeep;
- (BOOL) blockPredicate;

@end
