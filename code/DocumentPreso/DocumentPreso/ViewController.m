//
//  ViewController.m
//  DocumentPreso
//
//  Created by Josh Smith on 8/8/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "ViewController.h"
#import "MyManagedDocument.h"

@interface ViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *simpleTable;
@property (weak, nonatomic) IBOutlet UITableView *customTable;

@property (strong) NSFetchedResultsController *simpleFRC;
@property (strong) NSFetchedResultsController *customFRC;
@property (weak, nonatomic) IBOutlet UITextField *simpleName;
@property (weak, nonatomic) IBOutlet UITextField *simpleQuant;
@property (weak, nonatomic) IBOutlet UIButton *simpleAdd;

@property (weak, nonatomic) IBOutlet UITextField *customName;
@property (weak, nonatomic) IBOutlet UITextField *customQuant;
@property (weak, nonatomic) IBOutlet UIButton *customAdd;

@property (strong, nonatomic) UIManagedDocument *simpleDocument;
@property (strong, nonatomic) MyManagedDocument *customDocument;
@property (strong, nonatomic) NSMapTable *map;

@end

@implementation ViewController

- (NSURL *) documentBaseURL {
    NSString* temppath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) lastObject];
    NSURL *docdirurl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",temppath]];
    return docdirurl;
}

- (void) setupSimpleDocument {
    
    self.simpleAdd.enabled = NO;
    
    NSURL *tempfile = [NSURL URLWithString:@"simpledoc.sqlite" relativeToURL:[self documentBaseURL]];
    self.simpleDocument = [[UIManagedDocument alloc] initWithFileURL:tempfile];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};
    self.simpleDocument.persistentStoreOptions = options;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[tempfile path]]) {
        [self.simpleDocument saveToURL:tempfile
                      forSaveOperation:UIDocumentSaveForCreating
                     completionHandler:^(BOOL success) {
                         // this block is invoked on the calling queue
                         self.simpleAdd.enabled = success;
                         [self.simpleFRC performFetch:nil];
                         [self.simpleTable reloadData];
                     }];
    } else {
        [self.simpleDocument openWithCompletionHandler:^(BOOL success) {
                self.simpleAdd.enabled = success;
            [self.simpleFRC performFetch:nil];
            [self.simpleTable reloadData];
        }];
    }
}

- (void) setupSimpleFRC {

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
    self.simpleFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                         managedObjectContext:self.simpleDocument.managedObjectContext
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
    self.simpleFRC.delegate = self;
    
    [self.map setObject:self.simpleFRC forKey:self.simpleTable];
}

- (void) setupCustomDocument {
    NSURL *tempfile = [NSURL URLWithString:@"customdoc.sqlite" relativeToURL:[self documentBaseURL]];
    //NSURL *tempfile = [NSURL URLWithString:@"simpledoc.sqlite" relativeToURL:[self documentBaseURL]];

    self.customDocument  = [[MyManagedDocument alloc] initWithFileURL:tempfile];
    //self.customDocument  = [[UIManagedDocument alloc] initWithFileURL:tempfile];

    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                NSInferMappingModelAutomaticallyOption: @YES};
    self.customDocument.persistentStoreOptions = options;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[tempfile path]]) {
        [self.customDocument saveToURL:tempfile
                      forSaveOperation:UIDocumentSaveForCreating
                     completionHandler:^(BOOL success) {
                         // this block is invoked on the calling queue
                         self.customAdd.enabled = success;
                         [self.customFRC performFetch:nil];
                         [self.customTable reloadData];
                     }];
    } else {
        [self.customDocument openWithCompletionHandler:^(BOOL success) {
            self.customAdd.enabled = success;
            [self.customFRC performFetch:nil];
            [self.customTable reloadData];
        }];
    }}

- (void) setupCustomFRC {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:self.customDocument.mainEntityName];
    //NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
    self.customFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                         managedObjectContext:self.customDocument.managedObjectContext
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
    self.customFRC.delegate = self;
    [self.map setObject:self.customFRC forKey:self.customTable];
}
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory capacity:2];
    [self setupSimpleDocument];
    [self setupSimpleFRC];
    
    [self setupCustomDocument];
    [self setupCustomFRC];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController *frc = [self.map objectForKey:tableView];
    NSString *reuse = [frc isEqual:self.simpleFRC] ? @"simpleCell" : @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    NSManagedObject *obj = [frc objectAtIndexPath:indexPath];
    cell.textLabel.text = [obj valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Quant: %@",[obj valueForKey:@"quantity"]];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSFetchedResultsController *frc = [self.map objectForKey:tableView];
    id<NSFetchedResultsSectionInfo> currentSection = frc.sections[section];
    return [currentSection numberOfObjects];
}

- (void) insertSimpleName:(NSString *) name andQuant:(NSString *)quant {
    [self.simpleDocument.managedObjectContext performBlock:^{
        NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                                             inManagedObjectContext:self.simpleDocument.managedObjectContext];
        [obj setValue:name forKey:@"name"];
        
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        fmt.formatterBehavior = NSNumberFormatterDecimalStyle;
        [obj setValue:[fmt numberFromString:quant] forKey:@"quantity"];
    }];
}

- (IBAction)addSimple:(id)sender {
    if ([self.simpleName isFirstResponder]) {
        [self.simpleName resignFirstResponder];
    }
    
    if ([self.simpleQuant isFirstResponder]) {
        [self.simpleQuant resignFirstResponder];
    }
    [self insertSimpleName:self.simpleName.text andQuant:self.simpleQuant.text];
    self.simpleName.text = @"";
    self.simpleQuant.text = @"";
}

- (IBAction)addCustom:(id)sender {
    if ([self.customName isFirstResponder]) {
        [self.customName resignFirstResponder];
    }
    
    if ([self.customQuant isFirstResponder]) {
        [self.customQuant resignFirstResponder];
    }

    [self.customDocument insertNewEntity:self.customName.text withQuant:self.customQuant.text];
    
    self.customName.text = @"";
    self.customQuant.text = @"";
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([controller isEqual:self.simpleFRC]) {
        [self.simpleTable reloadData];
    }
    
    if ([controller isEqual:self.customFRC]) {
        [self.customTable reloadData];
    }
}

@end
