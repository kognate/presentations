//
//  RCWFlipsideViewController.m
//  ProjectOne-SpriteKit
//
//  Created by Josh Smith on 3/7/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "RCWFlipsideViewController.h"
@import SpriteKit;

@protocol SKAnimateDelegate <NSObject>

- (void) didAddBall;

@end

@interface MyScene : SKScene
@property (strong, nonatomic) UILabel *toUpdate;
@property (strong, nonatomic) id<SKAnimateDelegate> delegate;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFill;
        self.physicsWorld.gravity = CGVectorMake(0, -5);
        self.backgroundColor = [SKColor blackColor];
        
    }
    return self;
}

- (void) addBallAtTouch:(UITouch *) touch
{
    CGPathRef ball = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)] CGPath];
    SKShapeNode *sn = [[SKShapeNode alloc] init];
    sn.fillColor = [SKColor redColor];
    
    CGPoint loc = [touch locationInNode:self];
    sn.position = loc;
    
    sn.path = ball;
    sn.name = @"ball";
    sn.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    [self addChild:sn];
    self.toUpdate.text = [NSString stringWithFormat:@"Last Ball at %@",[NSDate date]];
    [self.delegate didAddBall];
}

- (void) didSimulatePhysics {
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *ball, BOOL *stop) {
        if (ball.position.y < 0) {
            [ball removeFromParent];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self addBallAtTouch:[touches anyObject]];
    NSLog(@"Begin");
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

@interface RCWFlipsideViewController ()
<SKAnimateDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@end


@implementation RCWFlipsideViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.toUpdate = self.totalCount;
    scene.delegate = self;

    // Present the scene.
    [skView presentScene:scene];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void) didAddBall {
    [UIView animateWithDuration:1.0 animations:^{
        self.totalCount.alpha = 0.8;
        }
                     completion:^(BOOL finished) {
                         self.totalCount.alpha = 1.0;
                     }];
}

@end
