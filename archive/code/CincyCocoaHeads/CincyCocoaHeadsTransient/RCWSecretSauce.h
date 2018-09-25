//
//  RCWSecretSauce.h
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 11/1/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWKeyChain.h"

@interface RCWSecretSauce : RCWKeyChain
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *card_type;
@property (strong,nonatomic) NSString *card_number;
@property (strong,nonatomic) NSString *card_cvv2;
@end
