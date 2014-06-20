//
//  SoundPlayer.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SoundManager.h"
#import "Constants.h"

@interface SoundPlayer : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (SoundPlayer*)sharedInstance;


- (SKAction*)getSoundActionFromFile:(NSString*)fileName;

- (void)playSound:(NSString*)fileName;
- (void)playMusic:(NSString*)fileName;

- (void)playSoundWithId:(uint32_t)soundId;

- (void)stopSoundsAndMusic;

@end
