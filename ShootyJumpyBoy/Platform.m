//
//  Platform.m
//  ShootyJumpyBoy
//
//  Created by Mark Meyer on 5/29/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "Platform.h"

@implementation Platform

- (id)initAtPoint: (CGPoint)point withRotation:(BOOL)rotate {
    if (rotate) {
        self = [Platform spriteNodeWithImageNamed:@"Wall"];
    } else {
        self = [Platform spriteNodeWithImageNamed:@"Platform"];
    }
    [self setScale:0.2];
    [self setZPosition:-1];

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = kWallCategory;
    self.physicsBody.dynamic = NO;
    //self.physicsBody.collisionBitMask ^= kPlayerProjectileCategory;
    self.position = point;
        
    SKAction *move = [SKAction moveToX:kXDeletePoint duration:2];
    
    [self runAction:[SKAction sequence:@[move, [SKAction removeFromParent]]]];

    return self;
}

@end
