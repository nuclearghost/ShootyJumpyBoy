//
//  SoundPlayer.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "SoundManager.h"

@interface SoundPlayer : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (SoundPlayer*)sharedInstance;

- (void)playSound:(NSString*)fileName;
- (void)playMusic:(NSString*)fileName;
- (void)stopSoundsAndMusic;

@end
