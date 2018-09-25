//
//  RCWKeyChain.h
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 11/1/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCWKeyChain : NSObject <NSCoding>

- (id) initWithKey:(NSString *) key;
- (void) save;
- (void) remove;



@end
