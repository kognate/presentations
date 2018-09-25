//
//  ViewController.m
//  CoreDataConcurrency
//
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Part.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *progressHolder;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *frc;
@property (strong, nonatomic) NSManagedObjectContext *childContext;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.frc = [[NSFetchedResultsController alloc] init];
    self.frc.delegate = self;
    AppDelegate *appdel = [UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *ctx =  appdel.managedObjectContext;
    self.childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.childContext.parentContext = ctx;
    
  
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"Here: %@",[NSThread currentThread]);
    AppDelegate *appdel = [UIApplication sharedApplication].delegate;
    [appdel.persistentStoreCoordinator performBlock:^{
        NSLog(@"Here: %@",[NSThread currentThread]);
        Part *p = [NSEntityDescription insertNewObjectForEntityForName:@"Part"
                                                inManagedObjectContext:self.childContext.parentContext];
        p.number = @(arc4random_uniform(1000));
        p.quantity = @(arc4random_uniform(30));
        p.storeNumber = @(arc4random_uniform(8));

        [self.childContext.parentContext performBlock:^{
            [self.childContext.parentContext save:nil];
        }];
    }];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Part"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"storeNumber" ascending:NO] ];
    req.fetchBatchSize = 20;
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                   managedObjectContext:self.childContext.parentContext
                                                     sectionNameKeyPath:@"storeNumber"
                                                              cacheName:nil];
    self.frc.delegate = self;

    NSError *error = nil;
    [self.frc performFetch:&error];
}

- (IBAction) fancyImport:(id)sender {
    
    self.progressHolder.hidden = NO;
    self.progressView.progress = 0.0;

    AppDelegate *appdel = [UIApplication sharedApplication].delegate;
    @autoreleasepool {
        NSManagedObjectContext *importContext = [appdel seperatePersistantStoreCoordinator];
        [importContext.persistentStoreCoordinator performBlock:^{
            [importContext performBlock:^{
                int i = 0;
                NSLog(@"Starting Import");
                while (i < 10000) {
                    i++;
                    Part *p = [NSEntityDescription insertNewObjectForEntityForName:@"Part"
                                                            inManagedObjectContext:importContext];
                    p.number = @(arc4random_uniform(1000));
                    p.quantity = @(arc4random_uniform(30));
                    p.storeNumber = @(arc4random_uniform(8));
                    if ((i % 100) == 0) {
                        NSError *error = nil;
                        BOOL success = [importContext save:&error];
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                float prog = i/10000.0;
                                [self.progressView setProgress:prog animated:YES];
                            });
                        }
                    }
                }
                NSError *importError;
                [importContext save:&importError];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressHolder.hidden = YES;
                    [self.childContext.parentContext reset];
                    [self.childContext reset];
                    [self.frc performFetch:nil];
                    [self.tableView reloadData];
                });
                NSLog(@"Ending Import");
            }];
            
        }];
    }
}

- (IBAction)didTapImport:(id)sender {

    self.progressHolder.hidden = NO;
    self.progressView.progress = 0.0;

    [self.childContext performBlock:^{
        int i = 0;
        NSLog(@"Starting Import");
        while (i < 10000) {
            i++;
             Part *p = [NSEntityDescription insertNewObjectForEntityForName:@"Part"
                                                inManagedObjectContext:self.childContext];
            p.number = @(arc4random_uniform(1000));
            p.quantity = @(arc4random_uniform(30));
            p.storeNumber = @(arc4random_uniform(8));
            if ((i % 100) == 0) {
                NSError *error = nil;
                BOOL success = [self.childContext save:&error];
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        float prog = i/10000.0;
                        [self.progressView setProgress:prog animated:YES];
                    });
                }
            }
        }
        [self.childContext.parentContext performBlock:^{
            NSError *parentError = nil;
            BOOL psuccess = [self.childContext.parentContext save:&parentError];
            if (psuccess) {
                self.progressHolder.hidden = YES;
            }
        }];
        NSLog(@"Ending Import");
    }];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"partCell"];
    }
    Part *p = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Part # %@ with %@ on hand",p.number,p.quantity];

    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.frc.sections count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.frc.sections count] > section) {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (IBAction)count:(id)sender {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Part"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"quantity" ascending:YES]];
    req.predicate = [NSPredicate predicateWithFormat:@"quantity > 1"];
    [NSThread sleepForTimeInterval:1];
    NSArray *res = [self.childContext executeFetchRequest:req error:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Count"
                                                 message:[NSString stringWithFormat:@"Found %@",@([res count])]
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [av show];
}

- (IBAction)backgroundcount:(id)sender {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Part"];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"quantity" ascending:YES]];
    req.predicate = [NSPredicate predicateWithFormat:@"quantity > 1"];

    NSAsynchronousFetchRequest *afr = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:req completionBlock:^(NSAsynchronousFetchResult *result) {
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Count"
                                                         message:[NSString stringWithFormat:@"Found %@",@([result.finalResult count])]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
            [av show];

        });
    }];
    
    [self.childContext performBlock:^{
        [self.childContext.parentContext performBlock:^{
            [self.childContext.parentContext executeRequest:afr error:nil];
        }];

    }];
    
}

- (IBAction)updateOldWay:(id)sender {
    

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Part"];

    [self.childContext performBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.progressHolder.hidden = NO;
            self.progressView.progress = 0.0;
        });
        NSDate *start = [NSDate date];
        NSArray *interim = [self.childContext executeFetchRequest:req error:nil];
        NSLog(@"Fetch Took: %f",[start timeIntervalSinceNow]);
        [interim enumerateObjectsUsingBlock:^(Part *obj, NSUInteger idx, BOOL *stop) {
            obj.quantity = @(1);
            if ((idx % 100) == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    float prog = (float)idx/(float)[interim count];
                    [self.progressView setProgress:prog animated:YES];
                });
            }
            
        }];
        NSError *error = nil;
        if ([self.childContext save:&error]) {
            if ([self.childContext.parentContext save:&error]) {
                NSLog(@"That Took: %f",[start timeIntervalSinceNow]);
            } else {
                NSLog(@"Error(p): %@",[error localizedDescription]);
            }
        } else {
            NSLog(@"Error: %@",[error localizedDescription]);
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            self.progressHolder.hidden = YES;
        });

    }];

}

- (IBAction)updateBatch:(id)sender {
    NSDate *start = [NSDate date];
    
    NSBatchUpdateRequest *batchRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Part"];
    batchRequest.propertiesToUpdate = @{@"quantity": @(4)};
    batchRequest.resultType = NSStatusOnlyResultType;
    NSLog(@"%@",[NSDate date]);
    
    NSError *updateError;
    
    NSBatchUpdateResult *result = (NSBatchUpdateResult *)[self.childContext.parentContext
                                                          executeRequest:batchRequest
                                                          error:&updateError];
    
    if (result == nil) {
        NSLog(@"Error: %@", [updateError localizedDescription]);
    } else {
        [self.childContext.parentContext reset];
        [self.childContext reset];
        [self.tableView reloadData];
    }
    NSLog(@"That Took: %f",[start timeIntervalSinceNow]);
}


@end
