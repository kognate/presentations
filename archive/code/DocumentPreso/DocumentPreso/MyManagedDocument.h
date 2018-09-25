//
//  MyManagedDocument.h
//  DocumentPreso
//
//  Created by Josh Smith on 8/8/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface Product : NSManagedObjectModel
@property (strong) NSString *name;
@property (strong) NSNumber *quantity;
@end

@interface MyManagedDocument : UIManagedDocument
- (NSString *) mainEntityName;
- (void) insertNewEntity:(NSString *) name withQuant:(NSString *) quant;
@end
