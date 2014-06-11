//
//  GCHelper.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <GameCenter/GameCenter.h>

/**
 *  Unused class for game center
 */
@interface GCHelper : NSObject


+ (GCHelper*)sharedInstance;

- (void) authenticateLocalPlayer;

@end
