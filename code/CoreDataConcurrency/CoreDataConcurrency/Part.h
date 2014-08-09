//
//  Part.h
//  CoreDataConcurrency
//
//  Created by Josh Smith on 8/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Part : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * storeNumber;

@end
