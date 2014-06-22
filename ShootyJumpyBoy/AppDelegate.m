//
//  AppDelegate.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/25/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "AppDelegate.h"

#import "Flurry.h"
#import "FlurryAds.h"
#import "iRate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"SX36VDWCTTQJKWQ8547P"];
    [FlurryAds initialize:self.window.rootViewController];
    
    NSMutableDictionary *defaults = [[NSMutableDictionary alloc] initWithCapacity:4];
    [defaults setObject:[NSDate date] forKey:@"Launch"];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:@"high_score"];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"sound_effects"];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"music"];
    [defaults setValue:[NSNumber numberWithInt:0] forKey:@"controls"];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
}

@end
