//
//  ViewController.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
// Using notification center from http://stackoverflow.com/questions/21664295/hide-show-iads-in-spritekit

#import "ViewController.h"

#import "FlurryAds.h"

#import "StartScene.h"
#import "OptionsViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOptions:) name:@"showOptions" object:nil];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    SKScene * scene = [StartScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)showOptions:(NSNotification *)notification {
    OptionsViewController *ovc = [[OptionsViewController alloc] init];
    [self presentViewController:ovc animated:YES completion:^{
        NSLog(@"Options Presented");
    }];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [FlurryAds removeAdFromSpace:@"BANNER_MAIN_VIEW"];
    } else if ([notification.name isEqualToString:@"showAd"]) {
        [FlurryAds fetchAndDisplayAdForSpace:@"BANNER_MAIN_VIEW" view:self.view size:BANNER_TOP];
    }
}

@end
