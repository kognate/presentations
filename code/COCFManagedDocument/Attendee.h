//
//  Attendee.h
//  COCFManagedDocument
//
//  Created by Josh Smith on 9/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Attendee : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * city;

@end
