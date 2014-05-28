//
//  Player.h
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Constants.h"

@interface Player : SKSpriteNode

- (id)init;

@property (strong,nonatomic) SKAction *jumpAction;
@property (strong,nonatomic) SKAction *shootAction;

@end
