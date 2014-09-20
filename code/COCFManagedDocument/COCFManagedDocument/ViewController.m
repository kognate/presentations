//
//  ViewController.m
//  COCFManagedDocument
//
//  Created by Josh Smith on 9/19/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "ViewController.h"
@import CoreData;
#import "Attendee.h"
#import "MyDocumentSubclass.h"

@interface ViewController ()
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSFetchedResultsController *frc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupDocument];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Attendee"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:NO]];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                   managedObjectContext:self.document.managedObjectContext
                                                     sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.document closeWithCompletionHandler:^(BOOL success) {
       // do something here
    }];
}

- (void) setupDocument {
    NSURL *baseDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *fileURL = [baseDir URLByAppendingPathComponent:@"MyDocument"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:fileURL];
    
    
    
    NSDictionary *options;
    
/*    options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                 NSInferMappingModelAutomaticallyOption : @(YES)
                 }; */
    
 
    NSURL *iCloudBaseURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:@"iCloud.com.alltrails.DocumentPreso"];
    NSURL *iCloudURL = [iCloudBaseURL URLByAppendingPathComponent:@"MyCloudyDocument"];
    
    if (iCloudURL) {
    options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                 NSInferMappingModelAutomaticallyOption : @(YES),
                 NSPersistentStoreUbiquitousContentNameKey : @"MyCloudyDocument",
                 NSPersistentStoreUbiquitousContentURLKey : iCloudURL };
    } else {
        options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                     NSInferMappingModelAutomaticallyOption : @(YES) };
    }
    
    [self.document setPersistentStoreOptions:options];

    BOOL isDir = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path] isDirectory:&isDir]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            NSError *fetchError;
            if(![self.frc performFetch:&fetchError]) {
                NSLog(@"we have a problem!");
            } else {
                [self.tableView reloadData];
            }
        }];
    } else {
        [self.document saveToURL:fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   NSError *fetchError;
                   if(![self.frc performFetch:&fetchError]) {
                       NSLog(@"we have a problem!");
                   }
               }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                      object:self.document.managedObjectContext.persistentStoreCoordinator
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.document.managedObjectContext performBlock:^{
                                                          [self.document.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
         }];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                      object:self.document.managedObjectContext.persistentStoreCoordinator
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      // disable user interface with setEnabled: or an overlay
                                                      [self.document.managedObjectContext performBlock:^{
                                                          if ([self.document.managedObjectContext hasChanges]) {
                                                              NSError *saveError;
                                                              if (![self.document.managedObjectContext save:&saveError]) {
                                                                  NSLog(@"Save error: %@", saveError);
                                                              }
                                                          } else {
                                                              // drop any managed object references
                                                              [self.document.managedObjectContext reset];
                                                              [self.tableView reloadData];
                                                          }
                                                      }];
                                                  }]; 

}

- (void) clearFields {
    self.firstNameField.text = nil;
    self.lastNameField.text = nil;
    self.cityField.text = nil;
}

- (IBAction)canceled:(UIButton *)sender {
    [self clearFields];
}

- (IBAction)save:(UIButton *)sender {

    [self.document.managedObjectContext performBlock:^{
        Attendee *person = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee"
                                                         inManagedObjectContext:self.document.managedObjectContext];
        person.firstName = self.firstNameField.text;
        person.lastName = self.lastNameField.text;
        person.city = self.cityField.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearFields];
        });
    }];
    
    
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger numberofrows = 0;
    NSArray *sections = [self.frc sections];
    if (sections > 0) {
        id<NSFetchedResultsSectionInfo> currentSection = sections[section];
        numberofrows = [currentSection numberOfObjects];
    }
    return numberofrows;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        Attendee *person = [self.frc objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName];
        cell.detailTextLabel.text = person.city;
    }
    return cell;
}



@end
