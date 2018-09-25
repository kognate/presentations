//
//  SecretMessage.h
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SecretMessage : NSManagedObject

@property (nonatomic, retain) NSData * messageEncrypted;
@property (nonatomic, retain) NSString* message;

@end
