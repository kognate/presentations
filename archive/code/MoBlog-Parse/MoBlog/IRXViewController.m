//
//  IRXViewController.m
//  MoBlog
//
//  Created by Josh Smith on 5/19/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "IRXViewController.h"

@interface IRXViewController ()
@property (weak,nonatomic) IBOutlet UIView *noteView;
@property (weak,nonatomic) IBOutlet UITextView *noteBody;
@property (strong) NSArray *datasource;
@property (weak,nonatomic) IBOutlet UICollectionView *mainCollection;
@property (strong) NSPredicate *seguePredicate;
@end

@implementation IRXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datasource = @[ [NSMutableArray array], [NSMutableArray array]];
    self.seguePredicate = [NSPredicate predicateWithFormat:@"identifier like $SEGUENAME"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self loadFromParse];
        });

    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self loadFromParse];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction) showNote:(id) sender {
    self.noteView.hidden = NO;
}

- (IBAction) noteDone:(id) sender {
    self.noteView.hidden = YES;
    if ([self.noteBody isFirstResponder]) {
        [self.noteBody resignFirstResponder];
    }
    NSMutableArray *ar = [self.datasource objectAtIndex:0];
    PFUser *user = [PFUser currentUser];
    PFObject *note = [PFObject objectWithClassName:@"Note"];
    [note setValue:self.noteBody.text forKey:@"text"];
    [note setValue:user.username forKey:@"user"];
    [note saveEventually];
    [ar addObject:@{ @"text" : self.noteBody.text }];
    self.noteBody.text = @"";
    [self.mainCollection reloadData];
}

- (IBAction) takePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:^{}];
    } else {
        NSMutableArray *ar = [self.datasource objectAtIndex:1];

        [ar addObject:@{ @"image" : @""}];
        [self.mainCollection reloadData];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSMutableArray *ar = [self.datasource objectAtIndex:1];
    [ar addObject:@{ @"image" : smallImage}];

    PFFile *imgfile = [PFFile fileWithName:@"picture.png" data:UIImageJPEGRepresentation(smallImage, 1.0)];
    
    [imgfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject *pfimage = [PFObject objectWithClassName:@"Image"];
        PFUser *user = [PFUser currentUser];
        // set an acl if we want
        //pfimage.ACL = [PFACL ACLWithUser:user];
        
        [pfimage setValue:imgfile forKey:@"image"];
        [pfimage setValue:user.username forKey:@"user"];
        [pfimage saveInBackground];
    }];
    [self.mainCollection reloadData];
}

- (UICollectionViewCell *) setupNoteCellForIndexPath:(NSIndexPath *) ipath andCollectionvView:(UICollectionView *) cv {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"NoteCell" forIndexPath:ipath];
    NSDictionary *d = [[self.datasource objectAtIndex:ipath.section] objectAtIndex:ipath.row];
    UITextView *tv = (UITextView *)[cell viewWithTag:9];
    tv.text = d[@"text"];
    return cell;
}

- (UICollectionViewCell *) setupImageCellForIndexPath:(NSIndexPath *) ipath andCollectionView:(UICollectionView *) cv {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:ipath];
    NSDictionary *d = [[self.datasource objectAtIndex:ipath.section] objectAtIndex:ipath.row];
    UIImageView *iv = (UIImageView *)[cell viewWithTag:9];
    iv.image = d[@"image"];
    return cell;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return [self setupNoteCellForIndexPath:indexPath andCollectionvView:collectionView];
            break;
        case 1:
            return [self setupImageCellForIndexPath:indexPath andCollectionView:collectionView];
        default:
            return nil;
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.datasource objectAtIndex:section] count];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSPredicate *_istext = [self.seguePredicate predicateWithSubstitutionVariables:@{@"SEGUENAME": @"textNoteSeg"}];
    NSPredicate *_isimage = [self.seguePredicate predicateWithSubstitutionVariables:@{@"SEGUENAME": @"imageNoteSeg"}];
    
    NSArray *ipaths = [self.mainCollection indexPathsForSelectedItems];
    NSIndexPath *current = [ipaths lastObject];
    NSDictionary *d = [[self.datasource objectAtIndex:current.section] objectAtIndex:current.row];
    if ([_istext evaluateWithObject:segue]) {
        UITextView *tv = (UITextView *)[[segue.destinationViewController view] viewWithTag:100];
        tv.text = d[@"text"];
    } else if ([_isimage evaluateWithObject:segue]) {
        UIImageView *iv = (UIImageView *)[[segue.destinationViewController view] viewWithTag:100];
        iv.image = d[@"image"];
    }
}

- (void) loadFromParse {
    PFUser *user = [PFUser currentUser];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"user = %@",user.username];

    PFQuery *notequery = [PFQuery queryWithClassName:@"Note" predicate:_pred];
    [notequery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSMutableArray *notes = [self.datasource objectAtIndex:0];
            [objects enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
                [notes addObject:@{@"text": [obj valueForKey:@"text"]}];
            }];
            [self.mainCollection reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
            
    PFQuery *imagequery = [PFQuery queryWithClassName:@"Image" predicate:_pred];
    [imagequery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *images = [self.datasource objectAtIndex:1];
            [objects enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
                PFFile *imgfile = [obj valueForKey:@"image"];
                UIImage *img = [UIImage imageWithData:[imgfile getData]];
                [images addObject:@{@"image": img}];
            }];
            [self.mainCollection reloadData];
            } else {
                        // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}



@end
