//
//  MyManagedDocument.m
//  DocumentPreso
//
//  Created by Josh Smith on 8/8/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "MyManagedDocument.h"

@implementation Product
@dynamic name;
@dynamic quantity;
@end

@interface MyManagedDocument ()
@property (strong, nonatomic) NSManagedObjectModel *privateModel;
@end

@implementation MyManagedDocument

- (NSString *) mainEntityName {
    return @"CustomProduct";
}

- (NSString *) persistentStoreTypeForFileType:(NSString *)fileType {
    return NSSQLiteStoreType;
}

- (NSManagedObjectModel *) managedObjectModel {
    if (self.privateModel == nil) {
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
        NSEntityDescription *entity = [[NSEntityDescription alloc] init];
        entity.name = [self mainEntityName];
        
        NSAttributeDescription *quant_attr = [[NSAttributeDescription alloc] init];
        quant_attr.name = @"quantity";
        quant_attr.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *name_attr = [[NSAttributeDescription alloc] init];
        name_attr.name = @"name";
        name_attr.attributeType = NSStringAttributeType;
        
        entity.properties = @[ quant_attr, name_attr];
        [model setEntities:@[entity]];
        self.privateModel = model;
    }
    return self.privateModel;
}

- (void) insertNewEntity:(NSString *)name withQuant:(NSString *)quant {
    [self.managedObjectContext performBlock:^{
        NSString *entName = self.mainEntityName;
        Product *obj = [NSEntityDescription insertNewObjectForEntityForName:entName
                                                             inManagedObjectContext:self.managedObjectContext];
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        fmt.formatterBehavior = NSNumberFormatterDecimalStyle;

        obj.name = name;
        obj.quantity = [fmt numberFromString:quant];
    }];
}

@end
