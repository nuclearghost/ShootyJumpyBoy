//
//  Enemy.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Constants.h"
#import "SoundPlayer.h"

@interface Enemy : SKSpriteNode

- (id)initEnemyOfType:(int32_t)type atPoint:(CGPoint)point;

- (BOOL)decrementHealthBy:(NSUInteger)amount;

- (void)setGroundContact:(BOOL)contact;

@property (strong,nonatomic) SKAction *jumpAction;

@end
