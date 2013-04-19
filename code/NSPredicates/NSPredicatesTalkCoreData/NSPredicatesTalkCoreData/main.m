//
//  main.m
//  NSPredicatesTalkCoreData
//
//  Created by Josh Smith on 1/8/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "Employee.h"
#import "Manager.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"NSPredicatesTalkCoreData";
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        NSError *error;
        
        // HEY:  we are deleting the DB EVERY SINGLE TIME!
        //NSFileManager *fm = [[NSFileManager alloc] init];
        //[fm removeItemAtURL:url error:&error];
        
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

static void saveAll()
{
    NSManagedObjectContext *context = managedObjectContext();
    NSError *error = nil;
    [context save:&error];
    if (error != nil) {
        NSLog(@"uh,oh %@",error);
    }
}

static void generateExampleData()
{
    NSManagedObjectContext *context = managedObjectContext();
    Manager *mng = [NSEntityDescription insertNewObjectForEntityForName:@"Manager"
                                                 inManagedObjectContext:context];
    mng.name = @"Grace";
    mng.departmentName = @"CodeMonkeys";
    NSMutableSet *emps = [mng mutableSetValueForKey:@"employees"];
    
    Employee *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Employee"
                                                  inManagedObjectContext:context];
    bill.name = @"Bill";
    bill.salary = @80000;
    
    Employee *jill = [NSEntityDescription insertNewObjectForEntityForName:@"Employee"
                                        inManagedObjectContext:context];
    jill.name = @"Jill";
    jill.salary = @91000;
    
    Employee *will = [NSEntityDescription insertNewObjectForEntityForName:@"Employee"
                                                   inManagedObjectContext:context];
    will.name = @"Will";
    will.salary = @90100;
    
    [emps addObjectsFromArray:@[ bill, jill, will]];
    saveAll();
}

void run_subquery(NSError **error_p, NSManagedObjectContext *context)
{
    // Subquery
    
    NSFetchRequest *_fetch = [[NSFetchRequest alloc] initWithEntityName:@"Manager"];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"SUBQUERY(employees,$e, $e.salary > 90000).@count > 0"];
    [_fetch setPredicate:_pred];
    NSArray *res = [context executeFetchRequest:_fetch error:&(*error_p)];
    NSLog(@"Expensive Manager %@",[[res lastObject] valueForKey:@"name"]);
}

void run_the_hard_way(NSError **error_p, NSManagedObjectContext *context)
{
    // Get the managers who have employees with salarys > 90000
    // The hard way
    
    NSFetchRequest *_emps = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSPredicate *_salarypred = [NSPredicate predicateWithFormat:@"salary > 90000"];
    
    [_emps setPredicate:_salarypred];
    
    NSArray *_empsSalary = [context executeFetchRequest:_emps error:&(*error_p)];
    __block NSMutableSet *expensive = [[NSMutableSet alloc] init];
    [_empsSalary enumerateObjectsUsingBlock:^(Employee *e,NSUInteger idx, BOOL *stop) {
        [expensive addObject:e];
    }];
    
    NSLog(@"Expensive Manager: %@",[[[expensive anyObject] valueForKey:@"manager"] valueForKey:@"name"]);
}

void simple_fetch_in_model(NSError **error_p, NSManagedObjectContext *context)
{
    // fetch request stored in the model
    
    NSFetchRequest *fetchManagers = [managedObjectModel() fetchRequestFromTemplateWithName:@"allManagers"
                                                                     substitutionVariables:@{}];
    NSArray *managers = [context executeFetchRequest:fetchManagers error:&(*error_p)];
    NSLog(@"First Manager: %@",[[managers lastObject] valueForKey:@"name"]);
    

    
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSError *error = nil;
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        generateExampleData();
        
        simple_fetch_in_model(&error, context);
        
        run_the_hard_way(&error, context);
        
        run_subquery(&error, context);
        
        saveAll();
    }
    return 0;
}

