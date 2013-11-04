//
//  RCWSecretSauce.m
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 11/1/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWSecretSauce.h"

@implementation RCWSecretSauce

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.card_type forKey:@"ctype"];
    [aCoder encodeObject:self.card_number forKey:@"cnum"];
    [aCoder encodeObject:self.card_cvv2 forKey:@"cvv"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.card_type = [aDecoder decodeObjectForKey:@"ctype"];
        self.card_number = [aDecoder decodeObjectForKey:@"cnum"];
        self.card_cvv2 = [aDecoder decodeObjectForKey:@"cvv"];
    }
    return self;
}
@end
