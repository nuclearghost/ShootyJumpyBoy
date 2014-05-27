//
//  GCHelper.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <GameCenter/GameCenter.h>

@interface GCHelper : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (GCHelper*)sharedInstance;

- (void) authenticateLocalPlayer;

@end
