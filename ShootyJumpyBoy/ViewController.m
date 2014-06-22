//
//  ViewController.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
// Using notification center from http://stackoverflow.com/questions/21664295/hide-show-iads-in-spritekit

#import "ViewController.h"

@interface ViewController()

@property (strong, nonatomic) ADBannerView *iAdView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOptions:) name:@"showOptions" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showShare:) name:@"showShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGameCenter:) name:@"showGameCenter" object:nil];

    //self.canDisplayBannerAds = YES;
    //SKView * skView = (SKView *)self.originalContentView;
    
    SKView *skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    
    [[GCHelper sharedInstance] authenticateLocalPlayerInViewController:self];
    
    SKScene * scene = [StartScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

#pragma mark notification handlers
/**
 *  Display the options view controller
 *
 *  @param notification unused
 */
- (void)showOptions:(NSNotification *)notification {
    OptionsViewController *ovc = [[OptionsViewController alloc] init];
    [self presentViewController:ovc animated:YES completion:^{
        NSLog(@"Options Presented");
    }];
}

/**
 *  show UIActivtyViewController to share high score
 *
 *  @param notifcation unused
 */
- (void)showShare:(NSNotification *)notifcation {
    double highScore = [[NSUserDefaults standardUserDefaults] doubleForKey:@"high_score"];
    NSString *string = [NSString stringWithFormat:@"I just got a high score of %.0f in Shooty Jumpy Boy", highScore];
    //NSURL *URL = [NSURL URLWithString:@"https://www.google.com"];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                      applicationActivities:nil];
    [self presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         NSLog(@"Completed sharing");
                                     }];
}

- (void)showGameCenter:(NSNotification *)notification {
    [[GCHelper sharedInstance] showLeaderboardInViewController:self];
}

/**
 *  Used to hide or show an ad
 *
 *  @param notification determine to show or hide ad
 */
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [FlurryAds removeAdFromSpace:@"SJB Game Over"];
    } else if ([notification.name isEqualToString:@"showAd"]) {
        //[FlurryAds fetchAndDisplayAdForSpace:@"SJB Game Over" view:self.view size:BANNER_TOP];
    }
}

#pragma mark GKGameCenterControllerDelegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
