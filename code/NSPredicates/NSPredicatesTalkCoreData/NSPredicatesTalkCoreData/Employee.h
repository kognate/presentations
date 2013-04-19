//
//  Employee.h
//  NSPredicatesTalkCoreData
//
//  Created by Josh Smith on 3/7/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manager;

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * salary;
@property (nonatomic, retain) Manager *manager;

@end
