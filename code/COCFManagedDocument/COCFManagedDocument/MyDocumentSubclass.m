//
//  MyDocumentSubclass.m
//  COCFManagedDocument
//
//  Created by Josh Smith on 9/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "MyDocumentSubclass.h"
@import CoreData;

@interface MyDocumentSubclass ()
@property (strong, nonatomic) NSManagedObjectModel *privateModel;
@end

@implementation MyDocumentSubclass

- (NSString *) persistentStoreTypeForFileType:(NSString *)fileType {
    //    return NSSQLiteStoreType;
    return NSBinaryStoreType;
}

/* - (NSManagedObjectModel *) managedObjectModel {
    if (self.privateModel == nil) {
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
        NSEntityDescription *entity = [[NSEntityDescription alloc] init];
        entity.name = @"Attendee";
        
        NSAttributeDescription *first_attr = [[NSAttributeDescription alloc] init];
        first_attr.name = @"firstName";
        first_attr.attributeType = NSStringAttributeType;
        
        NSAttributeDescription *last_attr = [[NSAttributeDescription alloc] init];
        last_attr.name = @"lastName";
        last_attr.attributeType = NSStringAttributeType;
        
        NSAttributeDescription *city_attr = [[NSAttributeDescription alloc] init];
        city_attr.name = @"city";
        city_attr.attributeType = NSStringAttributeType;
        
        entity.properties = @[ first_attr, last_attr, city_attr];
        [model setEntities:@[entity]];
        self.privateModel = model;
    }
    return self.privateModel;
} */

@end
