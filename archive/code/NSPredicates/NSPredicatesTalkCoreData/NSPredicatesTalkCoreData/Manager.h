//
//  Manager.h
//  NSPredicatesTalkCoreData
//
//  Created by Josh Smith on 1/8/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employee;

@interface Manager : NSManagedObject

@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *employees;
@end

@interface Manager (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(Employee *)value;
- (void)removeEmployeesObject:(Employee *)value;
- (void)addEmployees:(NSSet *)values;
- (void)removeEmployees:(NSSet *)values;

@end
