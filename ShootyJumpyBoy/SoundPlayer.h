//
//  SoundPlayer.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 6/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (SoundPlayer*)sharedInstance;

- (SKAction*)playSound:(NSString*)fileName;
- (SKAction*)playMusic:(NSString*)fileName;

@end
