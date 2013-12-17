//
//  Manager.m
//  NSPredicatesTalkCoreData
//
//  Created by Josh Smith on 1/8/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "Manager.h"
#import "Employee.h"


@implementation Manager

@dynamic departmentName;
@dynamic name;
@dynamic employees;

- (BOOL) validateForInsert:(NSError *__autoreleasing *)error {
    
    NSPredicate *nameGood = [NSPredicate predicateWithFormat:@"self.length > 0"];
    NSPredicate *departmentName = [NSPredicate predicateWithFormat:@"self.length > 0"];
    NSPredicate *all = [NSCompoundPredicate andPredicateWithSubpredicates:@[ nameGood, departmentName]];
    return [all evaluateWithObject:self];
}

@end
