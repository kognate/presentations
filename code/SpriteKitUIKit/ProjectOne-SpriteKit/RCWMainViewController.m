//
//  RCWMainViewController.m
//  ProjectOne-SpriteKit
//
//  Created by Josh Smith on 3/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "RCWMainViewController.h"

@implementation FireWorksView

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSString *ppath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
        SKEmitterNode *particles = [NSKeyedUnarchiver unarchiveObjectWithFile:ppath];
        particles.position = CGPointMake(0, 0);
        [self addChild:particles];
    }
    return self;
}
@end

@interface RCWMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *fwView;
@property (weak, nonatomic) IBOutlet SKView *fworks;

@end

@implementation RCWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FireWorksView *fwv = [FireWorksView sceneWithSize:self.fworks.bounds.size];
    [self.fworks presentScene:fwv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(RCWFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (IBAction)fireWorks:(id)sender {
    self.fwView.hidden = NO;
}

- (IBAction)dissmissFireWorks:(id)sender {
    CGPoint original_center = self.fworks.center;
    
    [UIView animateWithDuration:2
                     animations:^{
                         self.fworks.alpha = 0.0;
                         self.fworks.center = CGPointMake(-200, -200);
                     }
                     completion:^(BOOL finished){
                         self.fwView.hidden = YES;
                         self.fworks.alpha = 1.0;
                         self.fworks.center = original_center;
                     }];
}
@end
