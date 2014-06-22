//
//  GCHelper.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

@import GameKit;

/**
 *  Unused class for game center
 */
@interface GCHelper : NSObject  <GKGameCenterControllerDelegate>


+ (GCHelper*)sharedInstance;

- (void) authenticateLocalPlayerInViewController:(UIViewController*)presentingVC;
- (void) reportScore:(NSInteger)points;
- (void)showLeaderboardInViewController:(UIViewController *)presentingVC;

@end
